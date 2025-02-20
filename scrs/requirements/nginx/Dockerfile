FORM bulleye:latest

# L'option -y signifie que quand il sera demande Y/N pour download, yes sera envoyer automatiquement

# TLS est un protocole de sécurité qui assure le chiffrement, l'intégrité et l'authentification des données échangées entre deux systèmes.

RUN apt update \
	&& apt upgrade -y \
	&& apt install -y nginx \
	&& apt install -y openssl
	&& openssl req -x509 -nodes \
    -out /etc/nginx/ssl/inception.crt \
    -keyout /etc/nginx/ssl/inception.key \
    -subj "/C=FR/ST=Nouvelle-Aquitaine/L=Angouleme/O=42/OU=42/CN=rgobet.42.fr/UID=rgobet"

# Doit configurer nginx puis openssl car besoin des ports, domaine ..
# Apres l'acquisition d'un certificat il faut reload nginx (nginx -s reload)
# J'ai vu les deux etre fais en meme temps

# CMD permet d'éxecuter par defaut une commande dés le démarrage du conteneur

# nginx → Démarre le serveur Nginx.
# -g → Option qui permet de passer une directive globale à Nginx. (Obligatoire due a l'utilisation de Docker et est utiliser pour éditer le fichier nginx.conf)
# daemon off; → Empêche Nginx de passer en mode daemon (arrière-plan), ce qui est nécessaire dans un conteneur Docker. (permet d'empêcher le conteneur de s'arrêter directement)

# COPY permet de copier le dossier ou fichier default a l'emplacement qui suit.
# La config de nginx est default

COPY default /etc/nginx/sites-availables/.

CMD ["nginx", "-g", "daemon off;"]
