# BE521Final

Open a command prompt (windows)/terminal (Mac)

Install git!!!!

git clone https://github.com/tridentmakarov/BE521Final.git

cd /BE521Final

# Updating if there's changes

git pull
git reset --hard origin/master <<<not usually necessary, but if you're on master it shouldn't hurt

# If you want a new branch
	git checkout -b BRANCH_NAME  # Only if you want a new branch


# To push code!

git add .

git commit -m 'COMMIT MESSAGE'

git push


# First time, it'll error

Follow these instructions

https://help.github.com/en/articles/creating-a-personal-access-token-for-the-command-line

Sign in, 

Username: YOUR_USERNAME

Password: ACCESS_TOKEN_FROM_INSTRUCTIONS


# ANNOYING THING MATLAB DOES:

It'll do this "processing" thing, I recommend doing this:

Go to preferences, then Matlab  > General > Source Control

disable the automatic source control by selecting "None".

