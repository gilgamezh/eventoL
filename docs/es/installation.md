# Esta es la instalación para modo desarrollo
Hay dos opciones:
- Con docker (recomendada)
- Directamente en tu maquina

## Con Docker

### Obtener imagen de docker
Podes crear la tuya o tomar la generada de docker hub.

#### Tomar la imagen de docker hub
```bash
docker pull eventol/eventol:latest
```

#### Crear imagen local con todas las dependencias
```bash
docker build --tag=eventol/eventol:latest .
```

### Correr contenedores con esa imagen
```bash
# python
docker run -d -it --name eventol -v $PWD:/src -p 8000:8000 --workdir /src eventol/eventol:latest bash

# react
docker run -d -it --name eventoljs -v $PWD:/src -p 3000:3000 --workdir /src/eventol/front/ eventol/eventol:latest bash
```

### Crear la base de datos y actualizar estaticos
```bash
docker exec -it eventol ./deploy/scripts/install-container-dev.sh
```

### Correr el servidor para probar y desarrollar
```bash
# python
docker exec -it eventol ./eventol/manage.py runserver 0.0.0.0:8000

# react
docker exec -it eventoljs npm start
```

## Sin docker

### Npm
Nosotros estamos usando npm para las dependencias del frontend
* [Instalar npm y nodejs](https://github.com/joyent/node/wiki/Installing-Node.js-via-package-manager)

### Python 3
Nosotros estamos usando python 3.5 para correr el proyecto

### Instalar dependencias, crear la base de datos y actualizar estaticos

#### Hacerlo desde script
```bash
./deploy/scripts/install.sh
```

#### Hacerlo manualmente

##### Si usas virtualenv (si vas a instalar a mano es recomendable):
```bash
virtualenv -p python3 venv
source venv/bin/activate
```

##### Instalar dependencias de python
```bash
pip install -r requirements.txt -r requirements-dev.txt
```

##### Crear la base de datos y cargar datos de ejemplo
```bash
cd eventol
./manage.py migrate
./manage.py loaddata manager/initial_data/attendee_data.json
./manage.py loaddata manager/initial_data/email_addresses.json
./manage.py loaddata manager/initial_data/initial_data.json
./manage.py loaddata manager/initial_data/security.json
./manage.py loaddata manager/initial_data/software.json
cd -
```

##### Crear usuario admin
```bash
cd eventol
./manage.py createsuperuser
cd -
```

##### Instalar dependencias de node
```bash
sudo npm install -g less bower yarn
```

##### Instalar dependencias del frontend y compilar los css
```bash
cd eventol/front
yarn install
bower install
lessc eventol/static/manager/less/eventol.less > ../manager/static/manager/css/eventol.css
lessc eventol/static/manager/less/eventol-bootstrap.less > ../manager/static/manager/css/eventol-bootstrap.css
cd -
```

##### Juntar los archivos estaticos
```bash
./manage.py collectstatic --no-input
```

### Correr el servidor para probar y desarrollar
```bash
# python
./eventol/manage.py runserver 0.0.0.0:8000

# En otra terminal para react
cd eventol/front
npm start
```

# Actualizar traducciones

## Con Docker
```bash
docker exec -it eventol ./eventol/manage.py makemessages --locale=es
docker exec -it eventol ./eventol/manage.py compilemessages
```

## Sin Docker
```bash
django-admin makemessages --locale=es
django-admin compilemessages
```

# Configuración para inicio de sesión desde redes sociales

Una vez iniciado el server, visitamos la pagina de administración (Ejemplo: `http://localhost:8000/admin/`) y seguir los siguientes pasos:

* Añadir un sitio para su dominio, que se corresponda con `settings.SITE_ID` (` django.contrib.sites app`).
* Para cada proveedor basado en OAuth, añadir un Social App (socialaccount app).
* Complete los datos con el sitio y las credenciales de aplicaciones OAuth obtenidos del proveedor.

Para cualquier problema con las cuentas sociales, por favor verifique en la [documentación de django-allauth](http://django-allauth.readthedocs.org).

# Configurar visibilidad de actividades 

Utilizando la setting `PRIVATE_ACTIVITIES` se puede controlar si el listado de actividades es publico o únicamente accesible por organizadores.
