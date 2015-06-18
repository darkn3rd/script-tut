#!/usr/bin/ruby

# Abstract Concept to Determine How to Model Configuration Options

class ScriptBox
  ################ INITIALIZER ################
  def initialize(ostype, pkgmgr = ostype, shell = ostype)
    self.ostype = ostype   # set by global $operatingsystem

    if ostype == "darwin"
      if pkgmgr == ostype           # if dawrin pkgmgr not set
        self.pkgmgr = "homebrew"    # default to homebrew
      else
        self.pkgmgr = pkgmgr        # options: homebrew, ports, rudix, wget
      end
    elsif ostype == "windows"
      # Shell Environment (Only on Windows)
      if shell == ostype           # if shell not set
        self.shell = "cygwin"      # default of cygwin
      else
        self.shell = shell         # options: msys-git, uwin
      end

      # Package Manager Defaults
      if pkgmgr == ostype
        if shell == "cygwin"
          self.pkgmgr = "apt-cyg"  # default: apt-cyg if cygwin is shell
        else
          self.pkgmgr = "choco"    # default: choco
      else
        self.pkgmgr = pkgmgr       # options: pget, choco
      end
    else
      self.pkgmgr = pkgmgr         # all others *nix: use default pkgmgr
    end
  end

  ################ PROPERTIES ################
  attr_accessor :ostype, :shell, :pkgmgr
end

class Component
  def initialize(source = "package")
    self.source = source  # default: "package"
    self.method = method  # default: "package"
  end

  attr_accessor :source
end

class Java < Component
  def initialize(source, type = "oracle", version = "7")
    super(source)
    self.type = type       # oracle, openjdk
    self.version = version # 7, 8
  end

  attr_accessor :type, :version
end

class Groovy < Component
  def initialize(source, method = "gvm")
    super(source)
    self.method = method # package or gvm
  end

  attr_accessor :method
end

class Ruby < Component
  def initialize(source, method = "package")
    super(source)
    self.method = method # package or rvm
  end

  attr_accessor :method
end

class Perl < Component
  def initialize(source, type = "active")
    super(source)
    self.type = type # strawberry (WINDOWS ONLY), active
  end

  attr_accessor :type
end

class Posix
  def initialize(target)
    self.type = type # dash, ksh, ash, xpg, bash
  end

  attr_accessor :type
end
