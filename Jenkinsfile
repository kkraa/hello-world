pipeline {
    agent any
    stages {
            stage('Build') {
            steps {
             bat """
              set TESTDIR=C:/Users/%UID%/CTMAPI/202-convert-csv2json-using-python/
              PATH=%PATH%;%CTM_PATH%
              ctm env set TRAINING && ctm build %TESTDIR%/output_training.json -e TRAINING 
             """    
             }
             }
            stage('Run') {
            steps {
             bat """
             set TESTDIR=C:/Users/%UID%/CTMAPI/202-convert-csv2json-using-python/
             ctm session login 
             """
             }
             } 
            stage('Deploy') {
            steps {
             bat """
             set TESTDIR=C:/Users/%UID%/CTMAPI/202-convert-csv2json-using-python/
             ctm env set PROD && ctm deploy %TESTDIR%/output_training.json %TESTDIR%/DeployDesc_Test.json -e PROD
             """
             }
             } 
}
}
