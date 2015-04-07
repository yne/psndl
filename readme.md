# Data Base Refactoring
## Servers names
### Zeus

IPs :
	2.20.250.{89,82,123,90,153,74,72,81,105}

Aliases :
	zeus.dl.playstation.net
	zeus.psn.akadns.net
	a04.cdn.update.playstation.net
	zeus.dl.playstation.net.edgesuite.net
	playstation3.sony.akadns.net

### Apollo

Ips :
	2.20.250.{75,131}

Aliases :
	apollo.dl.playstation.net
	a02.cdn.update.playstation.net
	a02.cdn.update.playstation.org.edgesuite.net

### Ares (same as b0.ww.np) 

Ips :
	87.248.221.{253,254}

Aliases:
	ares.dl.playstation.net
	ares.psn.akadns.net
	al02.dl.playstation.net
	b0.ww.np.dl.playstation.net (b0.ww.np only)
	l02.cdn.update.playstation.net (b0.ww.np only)

### Synthesis

Each server name can be switched since they (almost all) goes to akamai servers.
So we don't need to store every .pkgs domain name.

## Game Ids

Games Ids are formated the following way :

```
BLES00000
^^^^
||||
|||+------ ??? (M...,S...,X...)
||+------- Region (Europe,Usa,Australia,Japan,Korea)
|+-------- Provider (C=sony, L=reselers, P=Demo)
+--------- Media type (Bluray/Network/Umd/S=PS1-PS2/T=Bundle)
```

### Validating code assertions 

All game ID are (4 letters + 5 digits)

```a.filter(function(c){return !a[c].match(/^\w{4}\d{5}$/)})```

Region can be guessed from the Game Id

```a.filter(function(a){return a[0][2]!=a[1][0]})```

Plateform can be guessed from Game Id

```a.filter(function(c){return (c[0][3]=="D")&&(c[3]!='PS2')})```

Every URL contain the game ID (all url must have bee converted to zeus.dl....)

```a.filter(function(c){return c[2].substr(42,9)!=c[0]})```

Every URL contain the same GameId suffix (_00)

```a.filter(function(c){return !c[2].match("_00/")})```


### Synthesis

Region,Plateform (PS1-2,PSP,PS3,PSV),type(Demo/Game/Theme?) can be found using Game ID
We don't need to store region and type suffix

## Conclusion

The following DB row :

```
NPEB01341;EU;http://zeus.dl.playstation.net/cdn/EP3643/NPEB01341_00/BwCJkfBGvZEXLOoyEMrkFbUQjwKyOVTeOYoVcgGSGDMXzmnTqzuqvrMleDgiCWVa.pkg;PSN;Hotline Miami;EP3643-NPEB01341_00-HOTLINEMIAMI0000.rap;B8FFA9447E1D5A3FAFC7B55852FA2956;;PSFreak
```

Will be converted to :

```
NPEB01341;EP3643;BwCJkfBGvZEXLOoyEMrkFbUQjwKyOVTeOYoVcgGSGDMXzmnTqzuqvrMleDgiCWVa;Hotline Miami;B8FFA9447E1D5A3FAFC7B55852FA2956;
```

# Usefull links :

- http://ps3tools.aldostools.org/raps.md5
- http://sonyindex.com/
