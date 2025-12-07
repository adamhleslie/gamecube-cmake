// REQUIREMENT: This pipeline uses 'agent any' with 'reuseNode true' for Docker stages
// This should work in both single-node and multi-node setups by keeping stages on the same node
pipeline {
    agent any
    options {
		    checkoutToSubdirectory('project')
		    disableConcurrentBuilds()
    }

    parameters {
        string(name: 'PROJECT_NAME', defaultValue: env.JOB_NAME, description: 'Name of project to be passed into cmake build.')
        booleanParam(name: 'CLEAN_BUILD', defaultValue: false, description: 'When true, will do a clean cmake build.')
    }

    stages {
        // If using an Inline Pipeline Script (not Pipeline from SCM), scm must be set up manually
        // Uncomment the following and remove the checkoutToSubdirectory option above
        // stage('Checkout') {
        //     steps {
        //         dir('project') {
        //             checkout scmGit(...)
        //         }
        //     }
        // }

        stage('Build') {
            agent {
                docker {
                    image 'devkitpro/devkitppc:latest'
                    reuseNode true
                    args """
                        -v $WORKSPACE/project:/workspace/project:ro
                        -v $WORKSPACE/build:/workspace/build:rw
                        -w /workspace
                    """
                }
            }
            environment {
                PROJECT_NAME = "$params.PROJECT_NAME"
            }
            steps {
                // CMake - Configure and Build
                cmakeBuild(
                    installation: 'InSearchPath',
                    sourceDir: 'project',
                    buildDir: 'build',
                    cmakeArgs: '-DCMAKE_TOOLCHAIN_FILE=cmake/devkitpro/toolchains/gamecube.toolchain.cmake',
                    cleanBuild: params.CLEAN_BUILD,
                    generator: 'Unix Makefiles',
                    steps: [[withCmake: true]]
                )
            }
        }

        stage('Archive') {
            steps {
                // Create version file using writeFile with Git environment variables
                // TODO: Fix this spacing:
                writeFile(file: 'build/version.txt', text: """
                    Git Commit: ${env.GIT_COMMIT ?: 'unknown'}
                    Git Branch: ${env.GIT_BRANCH ?: 'unknown'}
                    Build Tag: ${env.BUILD_TAG ?: 'unknown'}
                    Build URL: ${env.BUILD_URL ?: 'unknown'}
                """)

                // Compress build outputs using tar pipeline step, and automatically archive
                tar(file: 'archive/artifacts.tar.gz',
                    archive: true,
                    compress: true,
                    dir: 'build/',
                    glob: '*.elf,*.dol,version.txt',
                    overwrite: true
                )
            }
        }
    }
}