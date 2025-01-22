#!/bin/bash

# Sprawdzanie, czy jesteśmy w repozytorium Git
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
  echo "Nie znajdujesz się w repozytorium Git. Skrypt zatrzymany."
  exit 1
fi

MAIN_BRANCH="main"

# Upewnij się, że gałąź main istnieje
if ! git show-ref --verify --quiet refs/heads/$MAIN_BRANCH; then
  echo "Gałąź '$MAIN_BRANCH' nie istnieje. Upewnij się, że używasz poprawnej nazwy głównej gałęzi."
  exit 1
fi

# Aktualizuj zdalną gałąź
git fetch origin

# Jeśli rebase jest w toku, przerwij go
if [ -d ".git/rebase-apply" ] || [ -d ".git/rebase-merge" ]; then
  echo "Poprzedni rebase jest w toku. Anulowanie..."
  git rebase --abort
fi

# Sprawdź różnice z main
if git merge-base --is-ancestor origin/$MAIN_BRANCH HEAD; then
  echo "Gałąź jest już zsynchronizowana z $MAIN_BRANCH. Rebase nie jest potrzebny."
else
  echo "Wykonywanie rebase na $MAIN_BRANCH..."
  if ! git rebase origin/$MAIN_BRANCH; then
    echo "Rebase nie powiódł się. Przełączam na merge."
    git rebase --abort
    if ! git merge origin/$MAIN_BRANCH; then
      echo "Merge również nie powiódł się. Sprawdź stan repozytorium."
      exit 1
    fi
  fi
fi

# Pobranie hasha pierwszego commitu
ROOT_COMMIT=$(git rev-list --max-parents=0 HEAD)

# Pobranie commit messages
COMMIT_MESSAGE=$(git log --format=%B "$ROOT_COMMIT"..HEAD | grep -v '^$')

# Jeśli brak commit messages, ustaw domyślną wiadomość
if [ -z "$COMMIT_MESSAGE" ]; then
  echo "Brak commit messages. Użycie domyślnej wiadomości."
  COMMIT_MESSAGE="Squashed commit z zachowaniem zmian."
fi

# Resetowanie commitów do staging area
echo "Resetowanie commitów..."
git reset --soft "$ROOT_COMMIT"

# Tworzenie pojedynczego commitu
echo "Tworzenie pojedynczego commitu..."
git commit -m "$COMMIT_MESSAGE"

# Wypchnięcie zmian z nadpisaniem historii
echo "Pushowanie zmian..."
git push --force

echo "Squash zakończony i zmiany zostały wypchnięte."
