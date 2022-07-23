# automatic_ada_symbolic_execution
Herramienta para la ejecución simbólica de manera automática de código fuente Ada.

## Funcionamiento
A través de un sencillo formulario web se debe indicar un módulo y subir el código fuente empaquetado en un fichero .tar

Una vez subido el código fuente se analizarán todos los procedimientos incluidos en el fichero de especificación con el mismo nombre que el módulo indicado en el formulario. Por ejemplo, si el módulo indicado es "prueba" se analizarán todos los procedimientos incluidos en el paquete prueba.ads.

Automáticamente se creará un nuevo paquete con un código fuente que declare todas las variables necesarias para realizar las llamadas a los procedimientos encontrados, estableciéndola como simbólicas mediante el uso de las librerías de KLEE. Finalmente, una vez las variables han sido declaras y hechas simbólicas se realizarán las llamadas a todos los procedimientos, pasándoles como argumentos las variables necesarias. De esto modo se ejecutaría la aplicación de manera simbólica.

Una vez generados mediante el uso de gnat-llvm los bytecodes del código fuente generado más un bytecode que incluya los bytecodes de cada uno de los paquetes incluidos en el tar (esto es necesario para linkarlo con el bytecode principal, al fin de marcar como internos todos los subprogramas dentro del código fuente proporcionado) se ejecuta simbólicamente la aplicación mediante KLEE, generando los casos de pruebas así como algunos errores en la ejecución.

Concluída la ejecución simbólica, se ejecutará la herramienta converter que se encargará de ejecutar los procedimientos declarados en el módulo de una manera concreta, utilizando los casos de prueba generados en la ejecución simbólica. La herramienta aaset creará automáticamente un nuevo paquete dentro de la herramienta converter que declare todas las variables necesarias para la llamada a todos los procedimientos declarados en la especificación del módulo indicado (de la misma manera que el código fuente para realizar la ejecución simbólica). Luego, leerá en el mismo orden en que fueron declaradas, tomadas como argumentos de ejecución una representación en entero de cada variable, obteniendo dicha representación de los casos de prueba, y convirtiendo esa representación en entero en un objeto del tipo correspondiente a cada variable. Cuando todas las variables estén asignadas a los valores del caso de prueba a analizar se realizarán las llamadas a todos los procedimientos declarados en la especificación del módulo, ejecutándose la aplicación de manera concreta, con el fin de buscar errores en tiempo de ejecución para cada uno de los casos de pruebas generados por KLEE durante la ejecución simbólica.

Por cada error encontrado en la ejecución simbólica o concreta en cada caso de prueba se generará un fichero .txt con la información del caso de prueba y los errores en cuestión. Finalmente, se convertirán todos esos ficheros .txt en el reporte en formato JSON con toda la información para ser presentada al usuario. Asimismo, también se devolverá un JSON con los errores de compilación en el caso de que el código fuente para realizar la ejecución simbólica no pueda ser generado, ya sea por errores en el código fuente proporcionado o por algún error en la generación del nuevo código fuente. La cabecera 'Content-Type' de la respuesta está marcada como application/json por lo que dependiendo del navegador la visualización será distinta, pudiendo requerir la instalación de algún plugin para la presentación 'amigable' del reporte JSON.

## Prerequisitos

Para la ejecución de la herramienta es necesario tener instalado:

[gcc-11.3.0](https://gcc.gnu.org/install/index.html)

[llvm-13.0.0](https://llvm.org/)

[gnat-llvm](https://github.com/AdaCore/gnat-llvm)

[KLEE](https://klee.github.io/build-llvm11/)

## Instalación

automatic_ada_symbolic_execution utiliza web2py como Framework para el desarrollo del servidor web. web2py está incluido como un submódulo del presente repositorio, por lo que será necesario inicilializarlo al clonar el repositorio:
```
git clone --recurse-submodules https://github.com/mgarcp13/automatic_ada_symbolic_execution.git
```
Por defecto, el módulo web2py se inicializa al contenido del repositorio remoto, que no incluye la aplicación que implementa el servidor web. Esta aplicación se encuentra empaquetada dentro del directorio web-application. Este directorio contiene un subdirectorio llamado aaset y un fichero w2p que es un empaquetado de la aplicación para ser instalado a través de las opciones de administrador de web2py. Con el subdirectorio aaset se puede instalar la aplicación simplemente copiándolo al directorio web2py/application:
```
cp -r ./web-application/aaset ./web2py/applications
```

## Uso

Arrancar la aplicación web2py:
```
python3 web2py/web2py.py
```
Indicar una contraseña de administración, puerto e IP del servidor.

![Captura de pantalla 2022-07-23 142023](https://user-images.githubusercontent.com/9430650/180604618-d9cbb982-be56-48d8-acf3-8e29e0210aca.png)

Desde un navegador conectarse a la URL 127.0.0.1:8000/aaset/main/load

![Captura de pantalla 2022-07-23 141358](https://user-images.githubusercontent.com/9430650/180604488-b325831b-6ec1-4612-929d-ad8f4f05640c.png)

Introducir el módulo y subir un tar con el código fuente. Una vez generado el reporte se mostrará en formato JSON. La visualización dependerá del navegador y podría ser necesario la instalación de algún plugin para su correcta visualización.

![Captura de pantalla 2022-07-23 141848](https://user-images.githubusercontent.com/9430650/180604579-d3ddb588-1c55-463c-a57c-557c964c6333.png)
