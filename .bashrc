# ***** CUSTOM ALIASES *****
# Aliases Establishing custom commands below

# alias cons="cd /Users/mbp/Desktop/Desktop/Projects/personal/Wifi-Consumption/src && javac balance.java && javac WiFi.java && java balance && cd ~/Desktop"

alias cons="npm start --prefix ~/Desktop/Desktop/Projects/personal/sodetel"

alias cor="npm start --prefix ~/Desktop/Desktop/Projects/personal/corona"
alias corl="cor lebanon"

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

alias mongod="sudo mongod --dbpath /System/Volumes/Data/data/db"

# ***** CUSTOM FUNCTIONS *****
# RUNNING C & JAVA FILES
function runc { gcc "$1" && ./a.out "$2" "$3" ; }
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
	cp -r ~/.config/starship.toml "$output_dir/.config/starship.toml"

	# mv ".bashrc" ".bash_profile" ".zshrc" ".oh-my-zsh" ".config" "$output_dir"

}

function TSsetup {
	npm i --save-dev typescript ts-node @types/node &&
	npx tsc --init &&
	npmAddScript -k start -v "ts-node index.js" &&
	npmAddScript -k dev -v "nodemon --exec index.js"
}

# TO PUSH TO GITHUB PUSH ${MESSAGE}
function push { git add . && git commit -m "$1" && git push origin master ; }
function pushh { git add . && git commit -m "$1" && git push heroku master ; }

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

# EXTRACT PANOPTO VIDEO
function pan {

echo '
window.location = document.querySelector(`meta[property="og:video:secure_url"]`).content;
'
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

        if(!nameA.href.includes('GalaXXXy'))
			torrents.push({size, name: nameA.innerText, link: nameA.href});
	});

	torrents.sort((a,b) => b.size - a.size);
	torrents.forEach(({size, name, link}) => console.log(size + ' - ' + name +' - ' + link));

	const loadNext = confirm('load next set?');
	if(loadNext)
	    window.location = document.querySelector('.pagination .active').nextSibling.nextSibling.firstChild.href;
}

getLinksBetween(300, 700, 'MB');
"
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


function pptaudio {
	count=1;
	ppt_name="$1"
	zip_file="${ppt_name%.pptx}.zip"
	file_name="${zip_file%.zip}"
	output_dir="${file_name}-audio-files"
	
	mkdir "${output_dir}" && 
	sudo cp "$1" "${zip_file}" &&
	open -a "The Unarchiver.app" "${zip_file}" &&
	sleep 2 &&
	mv $file_name/ppt/media/*.m4a $output_dir &&
	# Not renaming in the correct order
	# for file in $file_name/ppt/media/*.m4a; do 
	# 	if ((count < 10)); then
    #     	mv $file  "$output_dir/0$((count++))-audio.m4a";
	# 	else
    #     	mv $file  "$output_dir/$((count++))-audio.m4a";
	# 	fi
	# done &&
	rm -rf "$zip_file" "$file_name";
}


# ***** R *****
# download caret and all its dependencies
function installCaret {
echo "
installCaret = function() {
install.packages('https://cran.r-project.org/bin/macosx/contrib/4.0/withr_2.2.0.tgz', dependencies=T)
install.packages('https://cran.r-project.org/bin/macosx/contrib/4.0/tibble_3.0.1.tgz', dependencies=T)
install.packages('https://cran.r-project.org/bin/macosx/contrib/4.0/scales_1.1.0.tgz', dependencies=T)
install.packages('https://cran.r-project.org/bin/macosx/contrib/4.0/rlang_0.4.5.tgz', dependencies=T)
install.packages('https://cran.r-project.org/bin/macosx/contrib/4.0/isoband_0.2.1.tgz', dependencies=T)
install.packages('https://cran.r-project.org/bin/macosx/contrib/4.0/gtable_0.3.0.tgz', dependencies=T)
install.packages('https://cran.r-project.org/bin/macosx/contrib/4.0/glue_1.4.0.tgz', dependencies=T)
install.packages('https://cran.r-project.org/bin/macosx/contrib/4.0/digest_0.6.25.tgz', dependencies=T)
install.packages('https://cran.r-project.org/bin/macosx/contrib/4.0/ggplot2_3.3.0.tgz', dependencies=T)
install.packages('https://cran.r-project.org/bin/macosx/contrib/4.0/R6_2.4.1.tgz', dependencies=T)
install.packages('https://cran.r-project.org/bin/macosx/contrib/4.0/lifecycle_0.2.0.tgz', dependencies=T)
install.packages('https://cran.r-project.org/bin/macosx/contrib/4.0/munsell_0.5.0.tgz', dependencies=T)
install.packages('https://cran.r-project.org/bin/macosx/contrib/4.0/colorspace_1.4-1.tgz', dependencies=T)
install.packages('https://cran.r-project.org/bin/macosx/contrib/4.0/ellipsis_0.3.0.tgz', dependencies=T)
install.packages('https://cran.r-project.org/bin/macosx/contrib/4.0/magrittr_1.5.tgz', dependencies=T)
install.packages('https://cran.r-project.org/bin/macosx/contrib/4.0/pillar_1.4.3.tgz', dependencies=T)
install.packages('https://cran.r-project.org/bin/macosx/contrib/4.0/crayon_1.3.4.tgz', dependencies=T)
install.packages('https://cran.r-project.org/bin/macosx/contrib/4.0/vctrs_0.2.4.tgz', dependencies=T)
install.packages('https://cran.r-project.org/bin/macosx/contrib/4.0/pkgconfig_2.0.3.tgz', dependencies=T)
install.packages('https://cran.r-project.org/bin/macosx/contrib/4.0/foreach_1.5.0.tgz', dependencies=T)
install.packages('https://cran.r-project.org/bin/macosx/contrib/4.0/iterators_1.0.12.tgz', dependencies=T)
install.packages('https://cran.r-project.org/bin/macosx/contrib/4.0/plyr_1.8.6.tgz', dependencies=T)
install.packages('https://cran.r-project.org/bin/macosx/contrib/4.0/Rcpp_1.0.4.6.tgz', dependencies=T)
install.packages('https://cran.r-project.org/bin/macosx/contrib/4.0/recipes_0.1.10.tgz', dependencies=T)
install.packages('https://cran.r-project.org/bin/macosx/contrib/4.0/timeDate_3043.102.tgz', dependencies=T)
install.packages('https://cran.r-project.org/bin/macosx/contrib/4.0/dplyr_0.8.5.tgz', dependencies=T)
install.packages('https://cran.r-project.org/bin/macosx/contrib/4.0/assertthat_0.2.1.tgz', dependencies=T)
install.packages('https://cran.r-project.org/bin/macosx/contrib/4.0/tidyselect_1.0.0.tgz', dependencies=T)
install.packages('https://cran.r-project.org/bin/macosx/contrib/4.0/purrr_0.3.4.tgz', dependencies=T)
install.packages('https://cran.r-project.org/bin/macosx/contrib/4.0/generics_0.0.2.tgz', dependencies=T)
install.packages('https://cran.r-project.org/bin/macosx/contrib/4.0/gower_0.2.1.tgz', dependencies=T)
install.packages('https://cran.r-project.org/bin/macosx/contrib/4.0/ipred_0.9-9.tgz', dependencies=T)
install.packages('https://cran.r-project.org/bin/macosx/contrib/4.0/prodlim_2019.11.13.tgz', dependencies=T)
install.packages('https://cran.r-project.org/bin/macosx/contrib/4.0/lava_1.6.7.tgz', dependencies=T)
install.packages('https://cran.r-project.org/bin/macosx/contrib/4.0/lubridate_1.7.8.tgz', dependencies=T)
install.packages('https://cran.r-project.org/bin/macosx/contrib/4.0/reshape2_1.4.4.tgz', dependencies=T)
install.packages('https://cran.r-project.org/bin/macosx/contrib/4.0/stringr_1.4.0.tgz', dependencies=T)
install.packages('https://cran.r-project.org/bin/macosx/contrib/4.0/stringi_1.4.6.tgz', dependencies=T)
install.packages('https://cran.r-project.org/bin/macosx/contrib/4.0/ModelMetrics_1.2.2.2.tgz', dependencies=T)
install.packages('https://cran.r-project.org/bin/macosx/contrib/4.0/data.table_1.12.8.tgz', dependencies=T)
install.packages('https://cran.r-project.org/bin/macosx/contrib/4.0/pROC_1.16.2.tgz', dependencies=T)
install.packages('https://cran.r-project.org/bin/macosx/contrib/4.0/e1071_1.7-3.tgz', dependencies=T)
install.packages('https://cran.r-project.org/bin/macosx/contrib/4.0/caret_6.0-86.tgz', dependencies=T)
}
installCaret()
"
}


# ***** ANACONDA *****
# added by Anaconda3 2019.10 installer
# >>> conda init >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$(CONDA_REPORT_ERRORS=false '/Users/mbp/opt/anaconda3/bin/conda' shell.bash hook 2> /dev/null)"
if [ $? -eq 0 ]; then
    \eval "$__conda_setup"
else
    if [ -f "/Users/mbp/opt/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/mbp/opt/anaconda3/etc/profile.d/conda.sh"
        CONDA_CHANGEPS1=false conda activate base
    else
        \export PATH="/Users/mbp/opt/anaconda3/bin:$PATH"
    fi
fi
# conda deactivate;
unset __conda_setup
# <<< conda init <<<
