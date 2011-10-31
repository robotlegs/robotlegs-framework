Maven usage
=====

Installation
------

__Step 1: Install Maven 3.0.3+__

[Download from here](http://maven.apache.org/download.html)

__Step 2: Ensure maven binaries are on your PATH (ie. you can run `mvn` from anywhere)__

Follow the installation instructions from [here](http://maven.apache.org/download.html#Installation).

__Step 3: CD to the robotlegs root (where the POM.xml lives)__

__Step 4: Install the third party dependencies into your local repository__

* In OS X

		bash -x maven-runonce.sh

* In Windows 
	
		maven-runonce.bat

>Note: we do this because unlike Ant, Maven requires all dependencies live within a repository somewhere. Because none of these dependencies are hosted externally on a remote repository, we need to install them locally into the repository. Going forward, the hope is that many of these dependencies will live in Maven Central, negating the need to install them locally. JM.

	
To build
-----
In order to build Robotlegs from source, run the following command in the Robotlegs root folder.

	mvn clean install -s settings.xml
	
	
Alternative to supplying settings
-----
If you would rather not supply `-s settings.xml` for every build, you can add the repository information from settings.xml into your local repository. Alternatively, you can simply copy the robotlegs settings.xml to `~/.m2/settings.xml` where ~ is your user directory (`\Users\username` in Win7+)
 
> __Why do we need the settings file?__ While Flexmojos lives within Maven Central, its dependencies (such as the Flex compiler) and flash project dependencies (such as framework SDKs) do NOT. They live within the flexgroup branch off (sonatype)[http://repository.sonatype.org/content/groups/flexgroup/].   