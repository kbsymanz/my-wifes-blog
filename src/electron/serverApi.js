/* 
 * -------------------------------------------------------------------------------
 * serverApi.js
 *
 * The Electron main process side of things.
 * ------------------------------------------------------------------------------- 
 */
const { dialog } = require('electron');
const fs = require('fs');
const path = require('path');
const jimp = require('jimp');
const _ = require('underscore');
const SSHClient = require('ssh2').Client;

const showOpenImageFileDialog = (startingPath='', multi=false) => {
  var properties = ['openFile'];
  if (multi) properties.push('multiSelections');
  const files = dialog.showOpenDialog({
    title: 'Choose an image',
    defaultPath: startingPath,
    properties: properties,
    filters: [
      { name: 'Image files', extensions: ['jpg','png','JPG','PNG'] }
    ]
  });
  if (files) return files;
  return [];
};


/* --------------------------------------------------------
 * createMasterImage()
 *
 * Copies to the specified master image file using the source
 * file. Returns the name of the master file.
 *
 * param       sourceFile       - full path to the source file
 * param       id               - the id of the file
 * param       imageDirectory   - the directory to write file to
 * return      masterFile       - file name of the new master file
 * -------------------------------------------------------- */
const createMasterImage = (sourceFile, id, imageDirectory) => {
  const masterFilename = 'master-' + id + path.extname(sourceFile);
  const masterFullPath = path.join(imageDirectory, masterFilename);
  fs.writeFileSync(masterFullPath, fs.readFileSync(sourceFile));
  return masterFilename;
};


/* --------------------------------------------------------
 * createImage()
 *
 * Creates a new image file based upon the source file passed
 * (assumes it is the master file), which is found in the
 * image directory passed, using the id and prefix to determine
 * the name, and the width to determine the size.
 *
 * param       sourceFile         - the source file name
 * param       id                 - the id
 * param       prefix             - the prefix to use
 * param       width              - the width to resize to
 * param       imageDirectory     - the image directory
 * param       cb                 - the callback
 * return      targetFilename     - the name of the new file
 * -------------------------------------------------------- */
const createImage = (sourceFile, id, prefix, width, imageDirectory, cb) => {
  const targetFilename = prefix + '-' + id + path.extname(sourceFile);
  jimp.read(path.join(imageDirectory, sourceFile), function(err, image) {
    if (err) throw err;
    image.clone()
      .resize(width, jimp.AUTO)
      .write(path.join(imageDirectory, targetFilename));
    return cb(targetFilename);
  });
};


/* --------------------------------------------------------
 * serverPublish()
 *
 * Pushes a post and it's images to a remote server via SSH
 * and kicks off a trigger command at the end. Returns boolean
 * success via the callback.
 *
 * param       sshHost          - the host of the SSH server
 * param       sshPort          - the port of the SSH server
 * param       sshUser          - the ssh username
 * param       sshPK            - the private key for the SSH connection
 * param       id               - the id of the post
 * param       postContent      - contents of the post
 * param       postRemoteDir    - remote directory for the post
 * param       imagesSrc        - array of image files, full paths
 * param       imageRemoteDir   - remote directory for images
 * param       triggerCmd       - command to run on the remote host
 * param       cb               - callback, Nodejs style with boolean success as 2nd parameter
 * return      
 * -------------------------------------------------------- */
const serverPublish = (sshHost, sshPort, sshUser, sshPK, id, postContent, postRemoteDir, imagesSrc, imageRemoteDir, triggerCmd, cb) => {
  var success = false;
  var port = parseInt(sshPort, 10);
  var sshConfig = {
    host: sshHost,
    port: port,
    username: sshUser,
    privateKey: sshPK,
    //debug: function(err) {console.log(err);}
  };

  var conn = new SSHClient();
  conn.on('ready', function() {
    conn.sftp(function(err, sftp) {
      if (err) throw err;
      const numImages = imagesSrc.length;
      var imagesDone = 0;

      // --------------------------------------------------------
      // Send the images to the server.
      // --------------------------------------------------------
      _.each(imagesSrc, (image) => {
        sftp.fastPut(image, path.join(imageRemoteDir, path.basename(image)), (err) => {
          if (err) console.log('Error with ' + image + ': ' + err);
          imagesDone++;
          if (imagesDone === numImages) {
            console.log('Finished sending ' + numImages + ' images to the server.');

            // --------------------------------------------------------
            // Send the post to the server, overwriting any existing
            // post with the same id.
            // --------------------------------------------------------
            const remoteFullPostPath = path.join(postRemoteDir, "Post-" + id + ".md");
            sftp.open(remoteFullPostPath, "w", function(err, postBufferHandle) {
              if (err) {
                console.log('Error with open for post: ' + err);
                return cb(err, false);
              }
              const postBuffer = Buffer.from(postContent);
              sftp.write(postBufferHandle, postBuffer, 0, postBuffer.length, 0, function(err) {
                if (err) {
                  console.log('Error with write for post: ' + err);
                  return cb(err, false);
                }
                sftp.close(postBufferHandle, function(err) {
                  if (err) {
                    console.log('Error with close for post: ' + err);
                    return cb(err, false);
                  }

                  // --------------------------------------------------------
                  // Execute the trigger command on the server.
                  // --------------------------------------------------------
                  conn.exec(triggerCmd, function(err, stream) {
                    stream.on('close', function(code, signal) {
                      conn.end();

                      // --------------------------------------------------------
                      // Return via callback to the caller.
                      // --------------------------------------------------------
                      if (code === 0) success = true;
                      return cb(null, success);
                    })
                    .on('data', function(data) {
                      console.log('STDOUT: ' + data);
                    })
                    .stderr.on('data', function(data) {
                      console.log('STDERR: ' + data);
                    });
                  });
                });
              });
            });
          }
        });
      });
    });
  })
  .on('error', function(err) {
    console.log('----------------- ERROR -------------------------');
    console.log(err);
    console.log('----------------- ERROR -------------------------');
    return cb(null, false);
  })
  .connect(sshConfig);

};

module.exports = {
  createImage: createImage,
  createMasterImage: createMasterImage,
  showOpenImageFileDialog: showOpenImageFileDialog,
  serverPublish: serverPublish
};
