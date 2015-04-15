# ZeinArmy
Your SwissArmy knife of the Unix world simplifying commonly used commands and executing common tasks Tasks better.

## 1. Installing
To install zeinarmy, run the install.sh script  

    sudo ./install.sh  
NOTE: The install location is /usr/bin/local but in future support for a custom install location is planned

## 2. Configuring
ZeinArmy allows you to configure commands by editing the config file (located at /etc/zeinarmy)  

## 3. Downloading stuff
 For faster downloads, ZeinArmy tries to use [aria2c](http://aria2.sourceforge.net/ "aria2c") first before resorting to the standard
wget. 

    zeinarmy.sh dl <url> <output name> 

OR 

    zeinarmy.sh dl <url>
## 4. Opening Stuff
 To open any file with the default program irrespective of the OS.

    zeinarmy.sh open <file>
## 5. Uncompress Files
Currently supported formats include tar, tar.gz, tar.xz, zip, tar.bz and rar archive formats. To uncompress a file, just type  

    zeinarmy uc <ARCHIVE_FILE>  
## 6. Compress File
Currently only tar.gz format is supported. 

    zeinarmy.sh c <OUTPUT_NAME> <FILE/FOLDER>  
## 7. Create new alias
To create a new alias(to be added to .bash_aliases file, just enter  

    zeinarmy.sh alias <ALIAS> <COMMAND>
## 8. File Permisions
To get the numerical value of file permissions(eg. 755, 442 etc)

    zeinarmy.sh chmod <FILE_ONE> <FILE_TWO> ...
## 9.Prepend to file
To prepends text to a file, 

    zeinarmy.sh prepend <TEXT> <FILE>

