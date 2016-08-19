# Forem
Short description and motivation.

## Usage
How to use my plugin.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'forem'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install forem
```

## TODO
- Assets diferentes en admin que en no-admin. Ahora ya cargamos 2 layouts
- Devise para usuarios
- Gestión de permisos. ¿CanCanCan?
- Topics
- Comments
- Replies
- Likes
- Enlazar topics, comments, replies entre foros (hacer referencia, como en slack)
- EMOJIS
- Markdown
- Buscar un editor de texto digno (quizá algo como slack es suficiente, con markdown y emojis)
- conrolar que los permalink no se repitan añadiendo números
- Integrar analytics
- Molaría como telegram, integración con giphy o algo similar
- Gestión de Assets. Carrierwave, eso está claro, pero con configuración
- Opción de poner foto portada a los foros ¿y topics?
- Ver como va la instalación para generar las vistas (¿selectivo rollo `rails g forem:views` y `rails g forem:admin_views`?)
- Integración con youtube, twitter, facebook y spotify para mostrar de forma chula sus enlaces (¿instagram?)
- Mantener en todos los controladores la respuesta json y html para que haga de API (¿opcional?)

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
