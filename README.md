# EcePrewarmer

Script para pre-calentar servidores escenic.

Se usa mas o menos así:

```bash
[host ]$ screen
[host ]$ unset http_proxy
[host ]$ ece-prewarmer -s www.24horas.cl -i 10.132.17.114 -p 8080 -v -t 8
```

## Installation

Install it yourself as:

    $ gem install ece_prewarmer

## Usage

```bash
[host]$ ece-prewarmer --help
Usage: ece-prewarmer --site [www.24horas.cl] --host [next-presentation-1.tvn.org]
    -s, --site=SITE                  El sitio web
    -i, --ipaddress=HOST             IP Address del servidor Presentation
    -p, --port=PORT                  El puerto destino, 80 por defecto
    -d, --depth=DEPTH                Limite de links a seguir
    -t, --threads=THREADS            Procesos a lanzar
    -V, --version                    Version
    -v, --verbose                    Mas debug
    -h, --help                       Esta ayuda
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/ece_prewarmer/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
