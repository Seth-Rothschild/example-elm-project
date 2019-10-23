module.exports = {
    entry: './src/static/index.js',
    output: {
        path: __dirname + '/dist',
	publicPath: '/assets/',
        filename: 'bundle.js'
    },
    module: {
        rules: [
            {
                test:    /\.elm$/,
                exclude: [/elm-stuff/, /node_modules/],
                loader:  'elm-webpack-loader?verbose=true',
            }
        ]
    },
    resolve: {
        extensions: ['.js', '.elm']
    },
    optimization: {
	minimize: false,
    },
    devServer: { 
	inline: true,
	port: 9000,
    }

}
