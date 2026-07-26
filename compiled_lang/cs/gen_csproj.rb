# Generates the throwaway .csproj each lesson is published from (see
# Makefile) - a Ruby script, not printf: printf isn't reliably
# available as a real executable (Make's $(SHELL) auto-detection falls
# back to cmd.exe, with no printf, when no POSIX shell is reachable on
# PATH - confirmed directly), while `ruby` is already a hard
# requirement for this whole project.
tfm, name, dest = ARGV

# $(NETCoreSdkRuntimeIdentifier) is MSBuild's own property reference,
# meant to be evaluated by MSBuild once this .csproj is loaded - not
# Ruby interpolation (which only ever expands "#{...}"), so it's
# already safe to write out literally with no escaping needed.
File.write(dest, <<~XML)
  <Project Sdk="Microsoft.NET.Sdk">
    <PropertyGroup>
      <OutputType>Exe</OutputType>
      <TargetFramework>net#{tfm}</TargetFramework>
      <RuntimeIdentifier>$(NETCoreSdkRuntimeIdentifier)</RuntimeIdentifier>
      <ImplicitUsings>disable</ImplicitUsings>
      <Nullable>disable</Nullable>
      <EnableDefaultCompileItems>false</EnableDefaultCompileItems>
      <AssemblyName>#{name}</AssemblyName>
      <PublishAot>true</PublishAot>
      <InvariantGlobalization>true</InvariantGlobalization>
      <BaseIntermediateOutputPath>obj/#{name}/</BaseIntermediateOutputPath>
    </PropertyGroup>
    <ItemGroup>
      <Compile Include="../src/#{name}.cs" />
    </ItemGroup>
  </Project>
XML
