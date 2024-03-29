# Ruby Detective
### Investigating your code dependencies

Ruby Detective is a gem that parses your code, finds it's dependencies and outputs an interactive .html file that you can use to explore the dependency network of the code.

This is the UI for the Ruby Detective project by the way:

### [Click here to access the live preview](https://victor-am.github.io/ruby_detective/preview.html)

[![Preview](docs/preview.png?raw=true)](https://victor-am.github.io/ruby_detective/preview.html)

***:** Due to Ruby metaprogramming super-powers (and by extension Rails heavy use of those) it's unfeasible to find every single dependency, so we can only guarantee that explicit constants will be pointed as dependencies.

## Main features
- Explorable and interactive network graph of the project dependencies
- Graph nodes colored by namespace, making it easier to spot contexts
- Useful information like lines of code, number of dependencies and dependents, etc
- Outputs a fully self-contained .html file that can be easily shared

## Installation
**Make sure you have Ruby 2.5 or higher installed (lower versions are not supported)**

```
gem install ruby_detective
```

## Usage

```
cd my-project-folder
ruby_detective .
```

This should output an html file at the end that is completely self-contained, and can be shared around with your peers :D

### Some tips
- Click on a node to bring it's card to the top of the list on the left
- Click twice on a node to add it to the graph, allowing to navigate through dependencies
- Use the filters on the right to customize the graph, toggling off the "Show second-level dependency edges" option can be specially useful

*This gem was inspired by @emad-elsaid library [rubrowser](https://github.com/emad-elsaid/rubrowser).*
