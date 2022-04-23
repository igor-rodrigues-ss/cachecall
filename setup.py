from setuptools import setup, find_packages


with open("README.md") as f:
    long_description = f.read()


setup(
    name="cachecall",
    version="0.0.2",
    description="A cache library for sync and async functions with ttl and expiration time.",
    long_description=long_description,
    long_description_content_type="text/markdown",
    url="https://github.com/igor-rodrigues-ss/cachecall",
    author="Igor Rodrigues Sousa Silva",
    author_email="igor.rodrigues.ss98@gmail.com",
    keywords="cache caching cachecall cached",
    license="MIT",
    classifiers=[
        "Development Status :: 3 - Alpha",
        "Intended Audience :: Developers",
        "Topic :: Software Development :: Build Tools",
        "License :: OSI Approved :: MIT License",
        "Programming Language :: Python :: 3.7",
        "Programming Language :: Python :: 3.8",
        "Programming Language :: Python :: 3.9",
        "Programming Language :: Python :: 3.10",
    ],
    packages=find_packages(),
    python_requires=">=3.7",
)
