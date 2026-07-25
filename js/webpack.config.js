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
        use: ['style-loader', 'css-loader'],
        // Some Mantine satellite packages (e.g. @mantine/spotlight 9.4.2)
        // declare "sideEffects": false in their own package.json with no
        // "*.css" exception (unlike @mantine/core, which does). In
        // production mode, webpack's tree-shaking then treats their
        // `import '.../styles.css'` as dead code (nothing consumes its
        // JS export) and silently drops it from the bundle - the CSS
        // still injects fine at dev/watch time (no tree-shaking there),
        // which is why this only breaks the built inst/www/mantine.js.
        // Symptom: components render with JS-set CSS variables that no
        // rule ever reads (e.g. Spotlight.ActionsGroup's `label`, set as
        // `--spotlight-label` but never shown, since the `content:
        // var(--spotlight-label)` rule that would display it never
        // loads). Force every *.css import to be treated as having side
        // effects, regardless of what the owning package declares.
        sideEffects: true
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
