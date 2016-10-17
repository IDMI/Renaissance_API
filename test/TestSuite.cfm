<cfinvoke component="coldbox.system.testing.compat.runner.DirectoryTestSuite"
          method="run"
          directory="#expandPath('integration')#"
          recurse="true"
          returnvariable="results"/>
<cfoutput>#results.getResultsOutput('html')#</cfoutput>