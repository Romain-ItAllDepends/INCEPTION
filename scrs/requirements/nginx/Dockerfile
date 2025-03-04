FROM debian:bullseye

# L'option -y signifie que quand il sera demande Y/N pour download, yes sera envoyer automatiquement

# TLS est un protocole de sécurité qui assure le chiffrement, l'intégrité et l'authentification des données échangées entre deux systèmes.

RUN apt update \
    && apt upgrade -y \
    && apt install -y nginx \
    && apt install -y openssl \
    && apt clean \
    && mkdir -p /etc/nginx/ssl \
    && openssl req -x509 -nodes \
    -out /etc/nginx/ssl/inception.crt \
    -keyout /etc/nginx/ssl/inception.key \
    -subj "/C=FR/ST=Nouvelle-Aquitaine/L=Angouleme/O=42/OU=42/CN=rgobet.42.fr/UID=rgobet"

# apt clean vide les fichiers en cache inutiles

# CMD permet d'éxecuter par defaut une commande dés le démarrage du conteneur

# nginx → Démarre le serveur Nginx.
# -g → Option qui permet de passer une directive globale à Nginx. (Obligatoire due a l'utilisation de Docker et est utiliser pour éditer le fichier nginx.conf)
# daemon off; → Empêche Nginx de passer en mode daemon (arrière-plan), ce qui est nécessaire dans un conteneur Docker. (permet d'empêcher le conteneur de s'arrêter directement)

# COPY permet de copier le dossier ou fichier default a l'emplacement qui suit.

COPY conf/nginx.conf /etc/nginx/nginx.conf

# Permet l'acces de /var/www/html avec nginx qui est dans le groupe www-data
# ### Maybe besoin de donner des droits particuliers mais j'en doute
RUN chown -R www-data:www-data /var/www/html

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
