#!/usr/bin/env groovy
// use collection loop on directory listing
//  item represents the file name
for (item in new File('.').list()) { 
<<<<<<< HEAD
    if (new File(item).isDirectory())
        println "$item is a directory"
    else
        println "$item is a not a directory"

}
=======
	if (new File(item).isDirectory())
		println "$item is a directory"
	else
	    println "$item is a not a directory"
}
>>>>>>> dfb804d74ee43c00020d8c86c8c809cff19bd565
