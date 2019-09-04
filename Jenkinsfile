#!/usr/bin/env groovy

timestamps {
    timeout(time: 5, unit: 'MINUTES') {
        node('dev') {

               checkout scm 
               //stash includes: '<your_scritp_name_here>', name: 'my_sql_script'
               sh(script: "echo 'dev'", returnStdout: true)

        }

        node('qa') {
               
               //unstash 'my_sql_script'
               sh(script: "echo 'qa'", returnStdout: true)

        }

        node('prod') {

               //unstash 'my_sql_script'
               sh(script: "echo 'prod'", returnStdout: true)

        }

    }
}
