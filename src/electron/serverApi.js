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
 * param       postContent      - contents of the post
 * param       postRemoteDir    - remote directory for the post
 * param       imagesSrc        - array of image files, full paths
 * param       imageRemoteDir   - remote directory for images
 * param       triggerCmd       - command to run on the remote host
 * param       cb               - callback, returns true or false
 * return      
 * -------------------------------------------------------- */
const serverPublish = (postContent, postRemoteDir, imagesSrc, imageRemoteDir, triggerCmd, cb) => {
  return cb(true);
};

module.exports = {
  createImage: createImage,
  createMasterImage: createMasterImage,
  showOpenImageFileDialog: showOpenImageFileDialog,
  serverPublish: serverPublish
};
