#!/bin/bash

# Chemin du fichier pour stocker le mot de passe
USER_FILE="user.txt"

# Fonction pour vérifier les informations de login et stocker l'identifiant/motdepasse
function login() {
    read -p "Login: " username
    read -s -p "Password: " password
    echo
    # Vérifier les informations de login
    # Comparer avec les identifiant et mot de passe stockés dans le fichier
    if grep -q "^$username/$password$" "$USER_FILE"; then
        main_prompt "$username/$password"
    else
        echo "Login ou mot de passe incorrect."
    fi
}

# Fonction principale du prompt
function main_prompt() {
    user_credentials=$1
    while true; do
        current_dir=$(pwd)
        read -p "$current_dir \$ " command
        case "$command" in
            help)
                help ;;
            ls)
                list_files ;;
            rm)
                remove_file ;;
            rmd|rmdir)
                remove_directory ;;
            about)
                about ;;
            version|--v|vers)
                version ;;
            age)
                check_age ;;
            quit)
                quit_prompt ;;
            profil)
                display_profile ;;
            passw)
                change_password "$user_credentials" ;;
            cd)
                change_directory ;;
            pwd)
                current_directory ;;
            hour)
                current_hour ;;
            httpget)
                httpget ;;
            smtp)
                smtp ;;
            open)
                open_file ;;
            rps)
                rps ;;
            rmdirwtf)
                rmdirwtf ;;
            *)
                echo "Commande inconnue. Tapez 'help' pour afficher les commandes disponibles." ;;
        esac
    done
}

# Fonction pour afficher les commandes disponibles
function help() {
    echo "Commandes disponibles :"
    echo "help : Affiche les commandes disponibles"
    echo "ls : Lister les fichiers et les dossiers visibles et cachés"
    echo "rm : Supprimer un fichier"
    echo "rmd ou rmdir : Supprimer un dossier"
    echo "about : Description du programme"
    echo "version, --v, vers : Affiche la version du prompt"
    echo "age : Vous demande votre âge et vous dit si vous êtes majeur ou mineur"
    echo "quit : Quitter le prompt"
    echo "profil : Afficher les informations sur vous-même"
    echo "passw : Changer le mot de passe avec confirmation"
    echo "cd : Aller dans un dossier ou revenir au dossier précédent"
    echo "pwd : Indique le répertoire actuel"
    echo "hour : Affiche l'heure actuelle"
    echo "* : Commande inconnue"
    echo "httpget : Télécharger le code source HTML d'une page web dans un fichier spécifique"
    echo "smtp : Envoyer un e-mail avec une adresse, un sujet et le corps du mail"
    echo "open : Ouvrir un fichier dans l'éditeur VIM"
    echo "rps : Jouer à pierre fueille ciseaux à 2 joueurs"
    echo "rmdirwtf : Supprimer un ou plusieurs dossiers (protégé par mot de passe)"
}

# Fonction pour la commande 'ls'
function list_files() {
    ls -la
}

# Fonction pour la commande 'rm'
function remove_file() {
    if [ $# -eq 1 ]; then
        file="$1"
        if [ -f "$file" ]; then
            rm "$file"
            echo "Fichier '$file' supprimé."
        else
            echo "Le fichier '$file' n'existe pas."
        fi
    else
        read -p "Entrez le nom du fichier à supprimer : " file
        if [ -f "$file" ]; then
            rm "$file"
            echo "Fichier '$file' supprimé."
        else
            echo "Le fichier '$file' n'existe pas."
        fi
    fi
}

# Fonction pour la commande 'rmd' ou 'rmdir'
function remove_directory() {
    if [ $# -eq 1 ]; then
        dir="$1"
        if [ -d "$dir" ]; then
            rm -r "$dir"
            echo "Dossier '$dir' supprimé."
        else
            echo "Le dossier '$dir' n'existe pas."
        fi
    else
        read -p "Entrez le nom du dossier à supprimer : " dir
        if [ -d "$dir" ]; then
            rm -r "$dir"
            echo "Dossier '$dir' supprimé."
        else
            echo "Le dossier '$dir' n'existe pas."
        fi
    fi
}

# Fonction pour la commande 'about'
function about() {
    echo "Mon Magic Prompt est un script interactif en ligne de commande avec diverses fonctionnalités."
    echo "Il permet de gérer des fichiers, des dossiers, de naviguer dans les répertoires et bien plus encore."
}

# Fonction pour la commande 'version'
function version() {
    echo "Version du prompt : 1.0"
}

# Fonction pour la commande 'age'
function check_age() {
    read -p "Quel est votre âge ? " age
    if [ "$age" -ge 18 ]; then
        echo "Vous êtes majeur."
    else
        echo "Vous êtes mineur."
    fi
}

# Fonction pour la commande 'quit'
function quit_prompt() {
    exit 0
}

# Fonction pour la commande 'profil'
function display_profile() {
    echo "Profil :"
    echo "Prénom: Dorian"
    echo "Nom: Haupas"
    echo "Age: 24 ans"
    echo "Email: dorian.haupas@my-digital-school.org"
}

# Fonction pour la commande 'passw'
function change_password() {
    user_credentials=$1  # Recevoir l'identifiant/motdepasse en argument
    stored_username=$(echo "$user_credentials" | cut -d'/' -f1)
    stored_password=$(echo "$user_credentials" | cut -d'/' -f2)
    read -s -p "Entrez votre nouveau mot de passe : " new_password
    echo
    read -s -p "Confirmez votre nouveau mot de passe : " confirm_password
    echo
    if [ "$new_password" == "$confirm_password" ]; then
        # Remplacer le mot de passe dans le fichier
        sed -i "s/$stored_username\/$stored_password/$stored_username\/$new_password/g" "$USER_FILE"
        echo "Mot de passe changé avec succès."
    else
        echo "Les mots de passe ne correspondent pas. Veuillez réessayer."
    fi
}

# Fonction pour la commande 'cd'
function change_directory() {
    read -p "Entrez le chemin du dossier : " directory
    if [ "$directory" == ".." ]; then
        cd .. || return
        echo "Vous êtes maintenant dans le répertoire parent."
    elif [ -d "$directory" ]; then
        cd "$directory" || return
        echo "Vous êtes maintenant dans : $directory"
    else
        echo "Le dossier n'existe pas."
    fi
}

# Fonction pour la commande 'pwd'
function current_directory() {
    pwd
}

# Fonction pour la commande 'hour'
function current_hour() {
    date +"Heure actuelle : %T"
}

# Fonction pour la commande 'httpget'
function httpget() {
    read -p "Entrez l'URL de la page web : " url
    read -p "Entrez le nom du fichier de destination : " filename
    if [ -z "$url" ]; then
        echo "L'URL est vide. Veuillez entrer une URL valide."
        return
    fi
    if [ -z "$filename" ]; then
        echo "Le nom du fichier est vide. Veuillez entrer un nom de fichier valide."
        return
    fi

    # Vérifier si le fichier existe déjà
    if [ -e "$filename" ]; then
        read -p "Le fichier '$filename' existe déjà. Voulez-vous le remplacer ? (O/n) " overwrite
        if [ "$overwrite" != "O" ]; then
            echo "Téléchargement annulé."
            return
        fi
    fi

    # Demander le dossier de téléchargement
    read -p "Entrez le chemin complet du dossier de téléchargement (appuyez sur Entrée pour le répertoire courant) : " download_dir
    if [ -z "$download_dir" ]; then
        download_dir="."  # Répertoire courant si aucun n'est spécifié
    fi

    # Vérifier si le dossier de téléchargement existe
    if [ ! -d "$download_dir" ]; then
        echo "Le dossier de téléchargement '$download_dir' n'existe pas. Veuillez créer le dossier ou spécifier un autre."
        return
    fi

    # Télécharger le fichier
    wget -q -P "$download_dir" -O "$download_dir/$filename" "$url"
    if [ $? -eq 0 ]; then
        echo "Fichier téléchargé avec succès : $download_dir/$filename"
    else
        echo "Échec du téléchargement. Veuillez vérifier l'URL et réessayer."
    fi
}

# Fonction pour la commande 'smtp'
function smtp() {
    read -p "Adresse e-mail : " email
    read -p "Sujet : " subject
    read -p "Corps du message : " body

    # Vérifier si le corps du message est vide
    if [ -z "$body" ]; then
        echo "Le corps du message est vide. Veuillez entrer un message."
        return
    fi

    # Envoi de l'e-mail
    echo -e "Subject: $subject\n\n$body" | sendmail "$email"
    if [ $? -eq 0 ]; then
        echo "E-mail envoyé avec succès."
    else
        echo "Échec de l'envoi de l'e-mail."
    fi
}

# Fonction pour la commande 'open'
function open_file() {
    read -p "Entrez le nom du fichier à ouvrir dans VIM : " file
    
    # Vérifier si le fichier existe, sinon le créer
    if [ ! -f "$file" ]; then
        echo "Le fichier n'existe pas. Création du fichier..."
        touch "$file"
    fi

    vim "$file"
}

# Variables pour les scores
player1_score=0
player2_score=0
rounds=3

# Fonction pour jouer à Rock Paper Scissors
function rps() {
    read -p "Entrez le nom du Joueur 1 : " player1
    read -p "Entrez le nom du Joueur 2 : " player2

    echo "Que la partie de Rock Paper Scissors commence entre $player1 et $player2!"

    for ((i=1; i<=$rounds; i++)); do
        echo "Manche $i :"

        # Joueur 1
        echo "$player1, à vous de jouer (Rock/Paper/Scissors) : "
        read player1_choice

        # Joueur 2
        echo "$player2, à vous de jouer (Rock/Paper/Scissors) : "
        read player2_choice

        # Déterminer le gagnant
        if [ "$player1_choice" == "$player2_choice" ]; then
            echo "Égalité dans cette manche!"
        elif [ "$player1_choice" == "Rock" ] && [ "$player2_choice" == "Scissors" ] ||
             [ "$player1_choice" == "Paper" ] && [ "$player2_choice" == "Rock" ] ||
             [ "$player1_choice" == "Scissors" ] && [ "$player2_choice" == "Paper" ]; then
            echo "$player1 remporte cette manche!"
            ((player1_score++))
        else
            echo "$player2 remporte cette manche!"
            ((player2_score++))
        fi
    done

    # Déterminer le vainqueur
    echo "Scores finaux :"
    echo "$player1 : $player1_score points"
    echo "$player2 : $player2_score points"

    if [ $player1_score -gt $player2_score ]; then
        echo "$player1 remporte la partie!"
    elif [ $player1_score -lt $player2_score ]; then
        echo "$player2 remporte la partie!"
    else
        echo "La partie se termine par une égalité!"
    fi
}

# Fonction pour la commande 'rmdirwtf'
function rmdirwtf() {
    read -s -p "Entrez le mot de passe pour 'rmdirwtf' : " password
    echo

    # Vérifier le mot de passe
    stored_password=$(<"$USER_FILE" cut -d'/' -f2)
    if [ "$password" != "$stored_password" ]; then
        echo "Mot de passe incorrect. Commande 'rmdirwtf' annulée."
        return
    fi

    # Supprimer les dossiers
    read -p "Entrez le nom du ou des dossiers à supprimer : " dirs
    rm -r $dirs
    echo "Dossier(s) supprimé(s) avec succès."
}

# Appel de la fonction de login au début du script
login
