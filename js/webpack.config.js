const path = require('path');

module.exports = {
  mode: 'production',
  entry: './src/index.js',
  output: {
    path: path.join(__dirname, '..', 'inst', 'www'),
    filename: 'mantine.js'
  },
  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        use: 'babel-loader'
      },
      {
        test: /\.css$/,
        use: ['style-loader', 'css-loader']
      }
    ]
  }
  // NOTA: a differenza del pattern standard di shiny.react (vedi shiny.fluent),
  // qui NON dichiariamo 'react'/'react-dom' come externals risolti su
  // jsmodule["react"]/jsmodule["react-dom"]. shiny.react condivide una copia
  // di React 18.3.1 tra tutti i pacchetti che usano quel meccanismo, ma
  // Mantine v9 richiede React >= 19.2 (peerDependencies verificata su npm) e
  // MantineProvider fa uso di comportamenti specifici di React 19 (style
  // hoisting). Con due React diversi che condividono lo stesso albero,
  // gli hook andrebbero in conflitto (dispatcher mismatch, "Invalid hook
  // call"): vedi la issue aperta github.com/Appsilon/shiny.react/issues/87.
  // Bundliamo quindi React 19 e ReactDOM 19 per intero dentro mantine.js,
  // come dipendenze normali (vedi package.json), isolati dal runtime di
  // shiny.react.
};
