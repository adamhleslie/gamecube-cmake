pipeline {
    agent any
    options {
        checkoutToSubdirectory('project')
        disableConcurrentBuilds()
    }

    parameters {
        string(name: 'PROJECT_NAME', defaultValue: env.JOB_NAME, description: 'Name of project to be passed into cmake build.')
        string(name: 'GENERATOR', defaultValue: 'Unix Makefiles', description: 'Name of the cmake generator to use.')
        string(name: 'TOOLCHAIN_FILE', defaultValue: 'cmake/devkitpro/toolchains/gamecube.toolchain.cmake', description: 'Name of the toolchain file to be used (CMAKE_TOOLCHAIN_FILE).')
        booleanParam(name: 'CLEAN_BUILD', defaultValue: false, description: 'When true, will do a clean cmake build.')
    }

    stages {
        // Note: If using an Inline Pipeline Script (not "Pipeline from SCM"), scm must be set up manually
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
                    cmakeArgs: "-DCMAKE_TOOLCHAIN_FILE=$params.TOOLCHAIN_FILE",
                    cleanBuild: params.CLEAN_BUILD,
                    generator: params.GENERATOR,
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