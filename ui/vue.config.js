const HtmlWebpackPlugin = require('html-webpack-plugin');
const InlineSourceWebpackPlugin = require('inline-source-webpack-plugin');

module.exports = {
  chainWebpack: (config) => {
    const svgRule = config.module.rule('svg');

    svgRule.uses.clear();

    svgRule
      .use('babel-loader')
      .loader('babel-loader')
      .end()
      .use('vue-svg-loader')
      .loader('vue-svg-loader');
  },
  configureWebpack: {
    plugins: [
      new HtmlWebpackPlugin({
        filename: 'index.html',
        title: 'Ruby Detective',
        template: 'public/index.html'
      }),
      new InlineSourceWebpackPlugin({
        compress: true,
        rootpath: './src',
        noAssetMatch: 'warn'
      })
    ]
  }
}
