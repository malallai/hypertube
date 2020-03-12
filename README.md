# README

Fast setup :

`gem install figaro`

`bundle exec figaro install`

Next edit `config/application.yml` and add this default env variables :

`HYPERTUBE_DATABASE_USERNAME: user`
`HYPERTUBE_DATABASE_PASSWORD: password`
`HYPERTUBE_DATABASE_HOST: db`
`HYPERTUBE_DISCORD_ID: 'your key here'`
`HYPERTUBE_DISCORD_SECRET: 'your key here'`
`HYPERTUBE_MARVIN_ID: 'your key here'`
`HYPERTUBE_MARVIN_SECRET: 'your key here'`
`THEMOVIEDB_KEY: 'your key here'`
`QBIT_HOST: 'http://qbit'`
`QBIT_PORT: '6880'`
`QBIT_USER: 'admin'`
`QBIT_PASS: 'adminadmin'`
`STORED_PATH: '/downloads'`

To start hypertube :

`make pull` and then `make up`

To restart `make re`

You can read logs with `make logs`
