pip install -r requirements.txt -r requirements-dev.txt
cd eventol
./manage.py migrate
./manage.py createsuperuser
./manage.py loaddata manager/initial_data/attendee_data.json
./manage.py loaddata manager/initial_data/email_addresses.json
./manage.py loaddata manager/initial_data/initial_data.json
./manage.py loaddata manager/initial_data/security.json
./manage.py loaddata manager/initial_data/software.json

sudo npm install -g less bower
# sudo npm install -g yarn
cd front
# yarn install
bower install
lessc eventol/static/manager/less/flisol.less > ../manager/static/manager/css/flisol.css
lessc eventol/static/manager/less/flisol-bootstrap.less > ../manager/static/manager/css/flisol-bootstrap.css
cd -

./manage.py collectstatic --no-input
./manage.py runserver

