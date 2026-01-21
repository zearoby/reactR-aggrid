var path = require('path');

module.exports = {
   entry: path.join(__dirname, 'srcjs', 'aggrid.jsx'),
   output: {
      path: path.join(__dirname, 'inst/htmlwidgets'),
      filename: 'aggrid.js'
   },
   module: {
      rules: [
         {
            test: /\.jsx?$/,
            loader: 'babel-loader',
            options: {
               presets: ['@babel/preset-env', '@babel/preset-react']
            }
         },
         {
            test: /\.mjs$/,
            include: /node_modules/,
            type: 'javascript/auto'
         }
      ]
   },
   externals: {
      'react': 'window.React',
      'react-dom': 'window.ReactDOM',
      'reactR': 'window.reactR'
   },
   devtool: 'source-map'
};
