# ZeinArmy
Your SwissArmy knife of the Unix world simplifying commonly used commands and executing common tasks Tasks better.

## 1. Installing
To install zeinarmy, run the install.sh script  

    ./install.sh 

## 2. Configuring
ZeinArmy allows you to configure commands by editing the config file (located at /etc/zeinarmy)  

## 3. Downloading stuff
 For faster downloads, ZeinArmy tries to use [aria2c](http://aria2.sourceforge.net/ "aria2c") first before resorting to the standard
wget. 

    zeinarmy.sh dl <url> <output name> 

OR 

    zeinarmy.sh dl <url>
## 4. Opening Stuff
 To open any file with the deafult program irrespective of the OS.

    zeinarmy.sh open <file>

