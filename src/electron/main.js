const {app, BrowserWindow} = require('electron');
const path = require('path');
const url = require('url');

let mainWindow = null;

app.on('ready', createMainWindow);

app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') {
    app.quit();
  }
});

function createMainWindow() {
  mainWindow = new BrowserWindow();
  mainWindow.loadURL(url.format({
    pathname: path.join(__dirname, 'index.html'),
    protocol: 'file',
    slashes: true
  }));

  mainWindow.on('closed', () => {
    mainWindow = null;
  });
}

