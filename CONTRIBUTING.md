# Contributing

## Issues, questions and pull requests
Please post issues and questions on the [Github issue tracker][github-issue].
I also welcome contributions so please feel free to submit pull requests too.
A template is provided when you create a pull request, so please make sure to fill it in so I get an idea of the change you are proposing.

Also, changes in behaviours should be included in the tests, so make sure to update the tests with your pull requests.


## Tests
Tests are all handled by [Test kitchen][test-kitchen] with [Docker][docker] so make sure you have docker installed to run the tests.
You will also need the [ChefDK][chefdk] to use the Test kitchen libraries.


Showing all available test suites
```
kitchen list
```

Converging a suite
```
kitchen converge <suite-name>
```

Verifing configurations
```
kitchen verify <suite-name>
```


[github-issue]: https://github.com/darwin67/chef-pyenv/issues
[test-kitchen]: https://kitchen.ci/
[docker]: https://www.docker.com/
[chefdk]: https://downloads.chef.io/chefdk
