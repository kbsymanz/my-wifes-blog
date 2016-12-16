
const saveConfig = (cfg) => {
  localStorage.setItem('config', JSON.stringify(cfg));
};

const getConfig = () => {
  var cfg = localStorage.getItem('config');
  if (cfg) return JSON.parse(cfg);
  return {};
};

const saveAuthors = (authors) => {
  localStorage.setItem('authors', JSON.stringify(authors));
};

const getAuthors = () => {
  var authors = localStorage.getItem('authors');
  if (authors) return JSON.parse(authors);
  return [];
};

const saveNextIds = (nextIds) => {
  localStorage.setItem('nextIds', JSON.stringify(nextIds));
};

const getNextIds = () => {
  var nextIds = localStorage.getItem('nextIds');
  if (nextIds) return JSON.parse(nextIds);
  return {};
};

const saveDefaultAuthor = (defaultAuthor) => {
  localStorage.setItem('defaultAuthor', JSON.stringify(defaultAuthor));
};

const getDefaultAuthor = () => {
  var defaultAuthor = localStorage.getItem('defaultAuthor');
  if (defaultAuthor) return JSON.parse(defaultAuthor);
  return null;
};

module.exports = {
  getConfig: getConfig,
  saveConfig: saveConfig,
  getAuthors: getAuthors,
  saveAuthors: saveAuthors,
  getNextIds: getNextIds,
  saveNextIds: saveNextIds,
  getDefaultAuthor: getDefaultAuthor,
  saveDefaultAuthor: saveDefaultAuthor
};
