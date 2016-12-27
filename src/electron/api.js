
const saveConfig = (cfg) => {
  localStorage.setItem('config', JSON.stringify(cfg));
};

const getConfig = () => {
  var cfg = localStorage.getItem('config');
  if (cfg) return JSON.parse(cfg);

  // Need to return an accurate empty representation
  // so that Elm does not blow up.
  return {
    serverImagesPushCmd: "",
    serverPostsPushCmd: "",
    serverTriggerCmd: "",
    postsDirectory: "",
    imagesDirectory: "",
    postCss: "",
    postTemplate: ""
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
  delPost: delPost
};
