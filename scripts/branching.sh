
REPOS='repo'
SVNBASE='https://svnhost/'
SVNREPOS='repo'

function rmbranch_one {
	if [ `git branch |grep -E "[[:space:]]+$1\$"|wc -l` -eq '1' ]; then
		git branch -D $1
	fi
}

function rmbranch {
	if [ "a"$1 = "a" ]; then
		echo "Usage: rmbranch <branch> kawdgfg"
		exit
	fi

	if [ "a"$2 != "akawdgfg" ]; then
		echo "Usage: rmbranch <branch> kawdgfg"
		exit
	fi

	for R in $REPOS; do
		pushd $R > /dev/null
		rmbranch_one $1
		popd > /dev/null
	done
}

function branchoff {
	if [ "a"$1 = "a" ]; then
		echo "Usage: branchoff.sh <remote> <local>"
		exit
	fi

	if [ "a"$2 = "a" ]; then
		echo "Usage: branchoff.sh <remote> <local>"
		exit
	fi

	function createbranch {
		pushd $1 > /dev/null
		if [ `git status |grep 'modified:'|wc -l` -eq '0' ]; then
			git co $2 && rmbranch_one $3 kawdgfg && git co -b $3
		else
			echo "$1 has modifications!"
		fi
		popd > /dev/null
	}

	for R in $REPOS; do
		createbranch $R $1 $2
	done
}

function svntrunkpath {
	if [ $1 = "common" ]; then	
		local path=$SVNBASE"/z/trunk/common/"
	else
		local path=$SVNBASE"/"$1"/trunk/"
	fi
	echo $path
}

function svnbranchpath {
	if [ $1 = "common" ]; then	
		local path=$SVNBASE"/z/branches/common/"
	else
		local path=$SVNBASE"/"$1"/branches/"
	fi
	echo $path
}

function svnrmbranch {
	if [ "a"$1 = "a" ]; then
		echo "Usage: svnrmbranch <branch> kawdgfg"
		exit
	fi

	if [ "a"$2 != "akawdgfg" ]; then
		echo "Usage: svnrmbranch <branch> kawdgfg"
		exit
	fi

	for R in $SVNREPOS; do
		local path=$(svnbranchpath $R)$1
		svn rm $path -m "|Removed branch $1"
	done
}

function svnbranchoff {
	if [ "a"$1 = "a" ]; then
		echo "Usage: svnbranchoff <source> <newbranch>"
		exit
	fi

	if [ "a"$2 = "a" ]; then
		echo "Usage: svnbranchoff <source> <newbranch>"
		exit
	fi

	for R in $SVNREPOS; do
		if [ $1 = "trunk" ]; then
			local sourcepath=$(svntrunkpath $R)
		else
			local sourcepath=$(svnbranchpath $R)$1
		fi

		local destpath=$(svnbranchpath $R)$2

		svn info $destpath > /dev/null 2>&1 || svn cp $sourcepath $destpath -m "|Created branch $2 from $1"
	done
}

if [ $0 = "branchoff" ]; then
	branchoff $1 $2
	exit
elif [ $0 = "rmbranch" ]; then
	rmbranch $1 $2
	exit
elif [ $0 = "svnrmbranch" ]; then
	svnrmbranch $1 $2
	exit
elif [ $0 = "svnbranchoff" ]; then
	svnbranchoff $1 $2
	exit
else
	echo "usage: [branchoff]"
fi


