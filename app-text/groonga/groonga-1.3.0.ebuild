# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
inherit eutils

DESCRIPTION="An Embeddable Fulltext Search Engine"
HOMEPAGE="http://groonga.org/"
SRC_URI="http://packages.groonga.org/source/groonga/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="abort aio benchmark debug dynamic-malloc-change +exact-alloc-count fmalloc futex libedit libevent lzo mecab msgpack +nfkc ruby sphinx static-libs uyield zeromq zlib"

RDEPEND="benchmark? ( >=dev-libs/glib-2.8 )
	libedit? ( >=dev-libs/libedit-3 )
	libevent? ( dev-libs/libevent )
	lzo? ( dev-libs/lzo )
	mecab? ( >=app-text/mecab-0.80 )
	msgpack? ( dev-libs/msgpack )
	ruby? ( dev-lang/ruby )
	sphinx? ( >=dev-python/sphinx-1.0.1 )
	zeromq? ( net-libs/zeromq )
	zlib? ( sys-libs/zlib )"
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.19
	sphinx? ( dev-python/sphinx )"

pkg_setup() {
	enewuser groonga || die
}

src_configure() {
	econf \
		$(use_enable abort) \
		$(use_enable aio) \
		$(use_enable benchmark) \
		$(use_enable debug memory-debug) \
		$(use_enable dynamic-malloc-change) \
		$(use_enable exact-alloc-count) \
		$(use_enable fmalloc) \
		$(use_enable futex) \
		$(use_enable libedit) \
		$(use_with libevent) \
		$(use_with lzo) \
		$(use_with mecab) \
		$(use_with msgpack message-pack) \
		$(use_enable nfkc) \
		$(use_with ruby) \
		$(use_with sphinx sphinx-build) \
		$(use_enable static-libs static) \
		$(use_enable uyield) \
		$(use_enable zeromq) \
		$(use_with zlib) || die
}

src_install() {
	emake DESTDIR="${D}" install || die

	#newinitd "${FILESDIR}/${PN}.initd" ${PN} || die
	#newconfd "${FILESDIR}/${PN}.confd" ${PN} || die

	keepdir /var/{log,spool}/${PN} || die
	fowners groonga:groonga /var/{log,spool}/${PN} || die

	dodoc AUTHORS ChangeLog NEWS README || die
}
