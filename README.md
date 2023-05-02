# Event-Guest-List-Automation

## Setup

### Credentials

Create/modify the credential files using

`rails credentials:edit --environment <ENVIRONMENT>`

following the format in `config/credentials.yml` and create/edit the `.env` file following the format in `.env.template`. Alternatively, if you have the PGP key, decrypt `master.key.gpg` in the `config` folder. Then copy over the credentials from running `rails credentials:edit` to the credentials for the production environment using `rails credentials:edit --environment production`.

### Email

Get a SendGrid API key or use a free mail service.  The default mail service defaults to `EMAIL_DOMAIN`, but can be changed to use `SENDGRID_DOMAIN` by setting `USE_SENDGRID=1` in the `.env` file. Also, edit the rails credentials with credentials for a default email and SendGrid.

### Docker

Install [docker](https://docs.docker.com/engine/install/) and [docker-compose](https://docs.docker.com/compose/install/) for your distribution.

In a terminal, run

`docker-compose up -d --build`

_(Subsequent use may omit the_ `-d` _and_ `--build` _flag.)_

Verify the containers are `up` by running `docker-compose up`. Then, set up the database by running

`docker-compose run rails rake db:create db:migrate db:seed`

_(Must be done if the_ `--build` _flag is used.)_

Stop the containers using

`docker-compose down`

_(Use_ `Ctrl-C` _to stop the containers if the_ `-d` _flag was omitted.)_

See the `documentation` folder for our current work.
