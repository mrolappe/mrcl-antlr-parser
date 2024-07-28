plugins {
    alias(libs.plugins.kotlin)
    antlr
    `maven-publish`
}

group = "de.rholambdapi.mrcl"
version = "0.1-SNAPSHOT"

java {
    sourceCompatibility = JavaVersion.VERSION_11
    targetCompatibility = JavaVersion.VERSION_11
    withSourcesJar()
}

repositories {
    mavenCentral()
    mavenLocal()
}

dependencies {
    antlr(libs.antlr4)

    testImplementation(kotlin("test"))
    testImplementation(libs.junitJupiterApi)
    testRuntimeOnly(libs.junitJupiterEngine)
    testImplementation(libs.kotestRunner)
    testImplementation(libs.kotestAssertionsCore)
}


publishing {
    publications {
        create<MavenPublication>("mrclAntlrParser") {
            from(components["java"])
        }
    }
}

tasks.generateGrammarSource {
    arguments = arguments + listOf("-package", "de.rholambdapi.mrcl.parser.antlr")
}

tasks.withType<AntlrTask>().configureEach {
    arguments.addAll(listOf("-visitor"))
}

tasks.test {
    useJUnitPlatform()
    systemProperty("kotest.framework.classpath.scanning.autoscan.disable", "true")
}

tasks.compileKotlin {
    dependsOn("generateGrammarSource")
}
tasks.compileTestKotlin {
    dependsOn("generateTestGrammarSource")
}

tasks.named("sourcesJar") {
    dependsOn("generateGrammarSource")
}

kotlin {
    jvmToolchain(11)
}