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
        title: 'Ruby Detective',
        template: 'html-loader!public/index.html.erb',
        filename: '../../views/template.html.erb'
      }),
      new InlineSourceWebpackPlugin({
        compress: true,
        rootpath: './src',
        noAssetMatch: 'warn'
      })
    ]
  }
}
