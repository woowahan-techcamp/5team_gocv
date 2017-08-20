const path = require('path');
const ExtractTextPlugin = require("extract-text-webpack-plugin");
const dir = path.resolve(__dirname, 'dist')


module.exports = {
    entry: './src/index.js',
    output: {
        filename: 'bundle.js',
        path: path.resolve(__dirname, 'dist'),
        publicPath: "/dist"
    },
    module: {
        rules: [{
            test: /\.js$/,
            exclude: /(node_modules|bower_components)/,
            use: {
                loader: 'babel-loader',
                options: {
                    presets: ['env']
                }
            }
        }, {
            test: /.css$/,
            use: ExtractTextPlugin.extract({
                fallback: 'style-loader',
                use: "css-loader",
            })
        }]
    },
    plugins: [
        new ExtractTextPlugin({
            filename:'styles.css'
        })
    ]

}

