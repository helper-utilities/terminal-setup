# ***** CUSTOM ALIASES *****
# Aliases Establishing custom commands below

# DEV
alias obp="code ~/.bash_profile"
alias obr="code ~/.bashrc"

alias treee="tree --ignore node_modules/ .git/ -f"
# alias condaa="conda activate"
# alias condad="conda deactivate"
# alias sqldev="sh /Applications/SQLDeveloper.app/Contents/Resources/sqldeveloper/sqldeveloper.sh"

alias npmd="npm i --save-dev"
alias npmu="npm uninstall"
alias tnode="ts-node"
alias tnodemon="ts-node-dev --respawn"

alias mongod="sudo mongod --dbpath /opt/homebrew/var/mongodb"

alias pskill="ps | awk {'print $1'} | awk 'NR>1' | xargs kill -9"

# ***** CUSTOM FUNCTIONS *****
# RUNNING C & JAVA FILES
function runc { gcc "$1" && ./a.out "$2" "$3" ; }
function runmpic { mpicc "$1" && mpirun -np "$2" ./a.out "$3" "$4" ; }
function runj { javac "$1" && java "$1" ; }
function runr { Rscript "$1" ; }
function runp { python3.7 "$1" ; }

function terminal-setup {
	mkdir -p "terminal-files/.config" &&
	output_dir="${PWD}/terminal-files" &&

	cp ~/.bashrc "$output_dir/.bashrc" &&
	cp ~/.bash_profile "$output_dir/.bash_profile" &&
	cp ~/.zshrc "$output_dir/.zshrc" &&
	sudo cp -r ~/.oh-my-zsh/ "$output_dir/.oh-my-zsh" &&
	cp -r ~/.config/starship.toml "$output_dir/.config/starship.toml" &&
	zip -r "$output_dir/.oh-my-zsh.zip" "$output_dir/.oh-my-zsh" &&
	sudo rm -r "$output_dir/.oh-my-zsh" &&
	clear && echo "terminal files copied successfully"
	# mv ".bashrc" ".bash_profile" ".zshrc" ".oh-my-zsh" ".config" "$output_dir"

}

function TSsetup {
	npm i --save-dev typescript ts-node @types/node &&
	npx tsc --init &&
	npmAddScript -k start -v "ts-node index.js" &&
	npmAddScript -k dev -v "nodemon --exec index.js"
}

# TO PUSH TO GITHUB PUSH ${MESSAGE}
function commit { git add . && git commit -m "$1" ; }
function uncommit { git reset --soft HEAD~$1 ; }
function push { git add . && git commit -m "$1" && git push ; }
function stash { git stash push -m "$1" -u -k ; }
function stash-staged { git stash push -m "$1" --staged ; }
function stash-unstaged { git stash push -m "$1" -u ; }

# ENCRYPT/DECRYPT A SINGLE FILE
function enc { openssl aes-256-cbc -in "$1" -out "$2" ; }
function dec { openssl aes-256-cbc -in -d "$1" -out "$2" ; }

# ZIP MULTIPLE FOLDERS
function mzip {
	for i in "$@"
		zip -r "$i.zip" "$i"
	; cat /dev/null > ~/.zsh_history ;
}

# ZIP & ENCRYPT MULTIPLE FOLDERS
function ezip {
	for i in "$@"
		zip -er "$i.zip" "$i"
	; cat /dev/null > ~/.zsh_history ;
}

# UNZIP & DECRYPT MULTIPLE FOLDERS
function uzip {
	for i in "$@"
		unzip "$i"
	; cat /dev/null > ~/.zsh_history ;
}

# DOWNLOAD YOUTUBE VIDEOS
function ytmp4 {
	# youtube-dl --abort-on-error --no-playlist -k --format 'bestvideo+bestaudio/best' $@;
	youtube-dl --abort-on-error --no-playlist --format 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/mp4' $@;
}

# DOWNLOAD YOUTUBE VIDEOS AS MP3
function ytmp3 {
	youtube-dl --abort-on-error --no-playlist --write-thumbnail --extract-audio --audio-format mp3 --audio-quality 192k --format 'best' $@;
}

function mkvtomp4 {
	for i in $@; do
		ffmpeg -i $i -c copy ${i%.mkv}.mp4;
	done
}

# EXTRACT TORRENT LINKS CODE
function tor {
echo "
function getLinksBetween(minSize=50, maxSize=700, byteSize='MB', minSeed=1) {

	link = window.location.href;
	const torrents = [];

	[...[...document.querySelectorAll('.table-list-wrap tbody tr')].filter(el => {

		const seeds = parseInt(el.querySelector('.seeds').innerText);
		const size = el.querySelector('.size').innerText.split(' ');

		// get links which are between min and max, and have at least minSeed number of seeds
		return seeds >= minSeed &&
			size[1].includes(byteSize) &&
			parseFloat(size[0]) > minSize &&
			parseFloat(size[0]) < maxSize;

	})].forEach(el => {

		const nameA = [...el.querySelectorAll('.name a')][1]; // name of link
		const size = parseFloat(el.querySelector('.size').innerText.split(' ')[0]);

        if(!nameA.href.includes('GalaXXXy') && !nameA.href.includes('XvX'))
			torrents.push({size, name: nameA.innerText, link: nameA.href});
	});

	torrents.sort((a,b) => b.size - a.size);
	torrents.forEach(({size, name, link}) => console.log(size + ' - ' + name +' - ' + link));

	const loadNext = confirm('load next set?');
	if(loadNext)
	    window.location = document.querySelector('.pagination .active').nextSibling.nextSibling.firstChild.href;
}

getLinksBetween(300, 900, 'MB');
" | pbcopy
}

function listPRs() {
echo "
function listPRs(name = 'JeffreyJoumjian') {
	function formatPRs(prs) {
		return prs.map((pr) => {
			const { repo, name, link } = pr;

			const repoNameCapitalized = repo
				.split('-')
				.map((text) => text.charAt(0).toUpperCase() + text.slice(1))
				.join('-');

			return '- [' + repoNameCapitalized + ']' +
				'[' + name + ']' +
				'(' + link + ')';
		}).join('\\\n');
	}

	const frontendRepos = ['introvoke-admin','introvoke-embed','introvoke-demos'];

	const githubBaseUrl = 'https://github.com';

	const PRs = [...document.querySelectorAll('.js-issue-row')]
		.filter((row) => {

		const assignee = row.querySelector(
			\`.AvatarStack-body[aria-label='Assigned to \${name}']\`
		);

		return Boolean(assignee);
	})
	.map((row) => {
		const repo = row
			.querySelector('.ghh-repo-x')
			.textContent.trim()
			.replace('introvoke/introvoke', 'introvoke')
			.replace('introvoke-', '')
			.replace('introvoke/', '');

		const repoLink = githubBaseUrl.concat(
			row.querySelector('.ghh-repo-x').getAttribute('href')
		);

		const name = row
			.querySelector('.ghh-issue-x')
			.textContent.trim()
			.replace('[', '(')
			.replace(']', ')');

		const link = githubBaseUrl.concat(
			row.querySelector('.ghh-issue-x').getAttribute('href')
		);

		return { repo, repoLink, name, link };
	});

	const frontendPRs = PRs.filter((pr) =>
		frontendRepos.some((repo) => pr.repoLink.includes(repo))
	);

	const backendPRs = PRs.filter(
		(pr) => !frontendRepos.some((repo) => pr.repoLink.includes(repo))
	);

	console.log(
		'*Frontend PRs*\\\n',
		'------------\\\n',
		formatPRs(frontendPRs),
		'\\\n','\\\n',
		'*Backend PRs*\\\n',
		'------------\\\n',
		formatPRs(backendPRs),
	);
}

listPRs();
" | pbcopy
}

# COMPRESS PDF FILES
function compdf {

	size=default
	start=2

	if [ "$1" = "-m" ]; then
		size=ebook
	elif [ "$1" = "-s" ]; then
		size=screen
	else
		start=1
	fi

	echo "compression: $size"

	for i in "${@:${start}}"
	do
		gs -sDEVICE=pdfwrite -dNOPAUSE -dQUIET -dBATCH -dPDFSETTINGS="/$size" -dPrinted=false -dCompatibilityLevel=1.4 -sOutputFile="compressed-$i" "$i"
	done

}

# fromwebp <format> <size> <img or dir> -i (if img and not dir>)
function fromwebp {
	format="$1"
	size="$2"
	dir="$3"

	# if directory
	if [ "$4" = "-d" ]; then
		output_dir="$dir/png"
		mkdir -p $output_dir &&
		for img in $dir/*.webp; do
			dwebp $img -quiet -o "${img%.webp}.${format}" -resize $size $size &&
			mv "${img%.webp}.${format}" $output_dir;
		done
	# if single image
	else
		dwebp $dir -quiet -o "${dir%.webp}.${format}" -resize $size $size;
	fi
}

# towebp <format> <img or dir> -i (if img and not dir>)
function towebp {
	format="$1"
	dir="$2"

	# if directory
	if [ "$3" = "-d" ]; then
		output_dir="$dir/webp"
		mkdir -p $output_dir &&
		for img in "$dir/*.${format}"; do
			cwebp $img -quiet -o "${img%.$format}.webp" &&
			mv "${img%.$format}.webp" $output_dir;
		done
	# if single image
	else
		cwebp $dir -quiet -o "${dir%.$format}.webp" ;
	fi
}


# # webpc <format> <img or dir> -i (if img and not dir>)
# function webpc32 {
# 	format="$1"
# 	dir="$2"

# 	w=32
# 	h=32

# 	# if directory
# 	if [ "$3" = "-d" ]; then
# 		output_dir="$dir/png"
# 		mkdir -p $output_dir &&
# 		for img in $dir/*.webp; do
# 			dwebp $img -quiet -o "${img%.webp}.${format}" -resize $w $h &&
# 			mv "${img%.webp}.${format}" $output_dir;
# 		done
# 	# if single image
# 	else
# 		dwebp $dir -quiet -o "${dir%.webp}.${format}" -resize $w $h;
# 	fi
#

# # webpc <format> <img or dir> -i (if img and not dir>)
# function webpc256 {
# 	format="$1"
# 	dir="$2"

# 	w=256
# 	h=256

# 	# if directory
# 	if [ "$3" = "-d" ]; then
# 		output_dir="$dir/png"
# 		mkdir -p $output_dir &&
# 		for img in $dir/*.webp; do
# 			dwebp $img -quiet -o "${img%.webp}.${format}" -resize $w $h &&
# 			mv "${img%.webp}.${format}" $output_dir;
# 		done
# 	# if single image
# 	else
# 		dwebp $dir -quiet -o "${dir%.webp}.${format}" -resize $w $h;
# 	fi
# }
# pngtojpg <img or dir> -i (if img and not dir>)
function pngtojpg {
	option=best

	dir="$1"

	# if directory
	if [ "$2" = "-d" ]; then
		output_dir="$dir/jpg"
		mkdir -p $output_dir &&
		for img in $dir/*.webp; do
			sips --setProperty format jpeg --setProperty "formatOptions" "$option" "${img}" --out "${img%.png}.jpg"
			mv "${img%.png}.jpg" $output_dir;
		done
	# if single image
	else
		sips --setProperty format jpeg --setProperty "formatOptions" "$option" "${dir}" --out "${dir%.png}.jpg"
	fi
}

PATH=~/.console-ninja/.bin:$PATH