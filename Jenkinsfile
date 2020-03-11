pipeline {
    agent any
    stages {
            stage('Build') {
                when {
                expression {
                    return env.BRANCH_NAME != 'master';
                }
            }              
            environment {
                ENDPOINT = 'https://cmemtrn:8443/automation-api'   
            }
            steps {
                sh '''
                username=$CONTROLM_CREDS_USR
                password=$CONTROLM_CREDS_PSW
                # Login
                login=$(curl -k -s -H "Content-Type: application/json" -X POST -d \\{\\"username\\":\\"$username\\",\\"password\\":\\"$password\\"\\} "$ENDPOINT/session/login" )
                token=$(echo ${login##*token\\" : \\"} | cut -d '"' -f 1)
                # Build
                curl -k -s -H "Authorization: Bearer $token" -X POST -F "definitionsFile=@ctmjobs/testjobs.json" "$ENDPOINT/build"
                curl -k -s -H "Authorization: Bearer $token" -X POST "$ENDPOINT/session/logout"
                '''
            }
        }
    }
}
