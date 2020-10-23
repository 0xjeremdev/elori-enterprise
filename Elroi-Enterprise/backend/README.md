#Instalation
1. run <code>pip install -r requirements.txt

After checkout please run: <code>python manage.py migrate</code>

* To send email after registration please update the file src/settings.py in the end
lines :

DEFAULT_FROM_EMAIL = 'target@email.com'\
EMAIL_USE_TLS = False\
EMAIL_HOST = 'smtp.mailtrap.io'\
EMAIL_HOST_USER = ''\
EMAIL_HOST_PASSWORD = ''\
EMAIL_PORT = '2525'\
 
 I used mailtrap.io for tests, 

#API Routes:
- <code>/api/auth/register</code> : url to register new user\
parameters to use:\````````
<code>
{
    "email": "",\
    "state_resident": (true or false),\
    "first_name": "",\
    "last_name": "",\
    "password": ""\
}
</code>

- <code>/api/auth/login</code> : url to login user\
parameters to use:\
{
    "email":"",
    "password":""
}\
returns: user object and token value