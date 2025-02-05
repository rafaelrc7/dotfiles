from setuptools import find_packages, setup

setup(
    name="hello",
    version="0.1.0",
    # Modules to import from other scripts:
    packages=find_packages(),
    # Executables
    scripts=["src/main.py"],
)
