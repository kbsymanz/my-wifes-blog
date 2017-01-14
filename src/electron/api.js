const path = require('path');
const { remote } = require('electron');
const {
  createImage,
  createMasterImage,
  showOpenImageFileDialog,
  serverPublish
} = remote.require('./serverApi.js');

const saveConfig = (cfg) => {
  localStorage.setItem('config', JSON.stringify(cfg));
};

const getConfig = () => {
  var cfg = localStorage.getItem('config');
  if (cfg) return JSON.parse(cfg);

  // Need to return an accurate empty representation
  // so that Elm does not blow up.
  return {
    serverImagesDirectory: "",
    serverPostsDirectory: "",
    serverTriggerCmd: "",
    postsDirectory: "",
    imagesDirectory: "",
    postCss: "",
    postTemplate: "",
    sshHost: "",
    sshPort: "22",
    sshUsername: "",
    sshPrivateKey: ""
  };
};

const saveAuthors = (authors) => {
  localStorage.setItem('authors', JSON.stringify(authors));
};

const getAuthors = () => {
  var authors = localStorage.getItem('authors');
  if (authors) return JSON.parse(authors);
  return [];
};

const delAuthor = (id) => {
  var authors = getAuthors();
  updatedAuthors = authors.filter(function(a) {
    return a.id !== id;
  });
  saveAuthors(updatedAuthors);
};

const saveNextIds = (nextIds) => {
  localStorage.setItem('nextIds', JSON.stringify(nextIds));
};

const getNextIds = () => {
  var nextIds = localStorage.getItem('nextIds');
  if (nextIds) return JSON.parse(nextIds);

  // Need to return an empty representation for Elm.
  return {
    nextAuthorId: 0,
    nextPostId: 0,
    nextImageId: 0
  };
};

const saveDefaultAuthor = (defaultAuthor) => {
  localStorage.setItem('defaultAuthor', JSON.stringify(defaultAuthor));
};

const getDefaultAuthor = () => {
  var defaultAuthor = localStorage.getItem('defaultAuthor');
  if (defaultAuthor) return JSON.parse(defaultAuthor);
  return null;
};

const postKey = (id) => {
  return "POST " + id;
};

const getPostKeys = () => {
  var postsStr = localStorage.getItem('posts');
  if (! postsStr) postsStr = "[]";
  var posts = JSON.parse(postsStr);
  return posts;
};

const savePost = (post) => {
  // Save the post in a key where we can find it.
  var key = postKey(post.id);
  localStorage.setItem(key, JSON.stringify(post));

  // Get the array of post ids we already have, if any.
  var posts = getPostKeys();

  // Add this post to the array if necessary and save.
  if (posts.indexOf(post.id) == -1) posts.push(post.id);
  localStorage.setItem('posts', JSON.stringify(posts));
};

const getPosts = () => {
  // Get the posts that we need to return.
  var posts = getPostKeys();

  // Get a list of posts to return.
  var postsList = posts.map(function(id) {
    const key = postKey(id);
    const postStr = localStorage.getItem(key);
    const post = JSON.parse(postStr);
    return post;
  });

  return postsList;
};

const delPost = (id) => {
  // Remove the post itself.
  var post = postKey(id);
  localStorage.removeItem(post);

  // Remove the post id from the index.
  var posts = getPostKeys();
  var newPosts = posts.filter(function(i) {
    return i !== id;
  });
  localStorage.setItem('posts', JSON.stringify(newPosts));
};

// Save the last path used for this session for selecting images.
// Saves the user having to navigate multiple directories for
// more than one image.
var lastPathUsed = '';

const uploadImage = (id, cb) => {
  // Get the images directory.
  var iDir = getConfig().imagesDirectory;

  // Allow user to select one for now, but can handle
  // multiple files when the Elm side is ready for it.
  var file = showOpenImageFileDialog(lastPathUsed, false)[0];

  // Generate master file, thumbnail file, and starting source file
  // with hard-coded width (for now).
  const width = 600;
  const thumbWidth = 120;
  if (file) {
    // Save the path for next time.
    lastPathUsed = path.dirname(file);

    // Create the master file.
    var masterFile = createMasterImage(file, id, iDir);

    // Create the thumbnail file.
    return createImage(masterFile, id, 'thumb', thumbWidth, iDir, function(thumbnailFile) {

      // Create the source file.
      createImage(masterFile, id, 'source', width, iDir, function(sourceFile) {
        return cb({
          id: id,
          masterFile: masterFile,
          sourceFile: sourceFile,
          thumbnailFile: thumbnailFile,
          width: width,
          rotation: 0
        });
      });
    });
  }
  return cb(void 0);
};

const publish = (id, postContent, cb) => {
  // TODO:
  // 3. Gather full path references for all images into an array.
  // 4. Get remote paths for post and images
  // 5. Get the trigger command.
  return cb(true);

};

module.exports = {
  getConfig: getConfig,
  saveConfig: saveConfig,
  getAuthors: getAuthors,
  saveAuthors: saveAuthors,
  delAuthor: delAuthor,
  getNextIds: getNextIds,
  saveNextIds: saveNextIds,
  getDefaultAuthor: getDefaultAuthor,
  saveDefaultAuthor: saveDefaultAuthor,
  savePost: savePost,
  getPosts: getPosts,
  delPost: delPost,
  uploadImage: uploadImage,
  publish: publish
};
