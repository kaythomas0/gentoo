# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{8..9} )
inherit distutils-r1

DESCRIPTION="hashicorp vault client in python"
HOMEPAGE="https://github.com/hvac/hvac"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/hvac/hvac.git"
else
	SRC_URI="https://github.com/hvac/hvac/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="Apache-2.0"
SLOT="0"

BDEPEND="
	test? (
		dev-python/flask-sqlalchemy[${PYTHON_USEDEP}]
		dev-python/jwcrypto[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/parameterized[${PYTHON_USEDEP}]
		dev-python/requests-mock[${PYTHON_USEDEP}]
		dev-python/semantic_version[${PYTHON_USEDEP}]
		dev-python/werkzeug[${PYTHON_USEDEP}]
	)"
RDEPEND="
	>=dev-python/pyhcl-0.4.4[${PYTHON_USEDEP}]
	>=dev-python/requests-2.24.0[${PYTHON_USEDEP}]
	>=dev-python/six-1.15.0[${PYTHON_USEDEP}]"

distutils_enable_tests pytest

python_test() {
	local ignore=(
		# ldap_test is not packaged.
		tests/integration_tests/api/auth_methods/test_ldap.py
		# https://github.com/lepture/authlib is not packaged.
		tests/integration_tests/api/auth_methods/test_oidc.py
	)

	epytest ${ignore[@]/#/--ignore }
}
