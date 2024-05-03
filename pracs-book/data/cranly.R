### cranly demonstration adapted from
### https://rviews.rstudio.com/2018/05/31/exploring-r-packages/

library(tools)
p_db <- CRAN_package_db()

library(cranly)
package_db <- clean_CRAN_db(p_db)

package_network <- build_network(package_db)
package_summaries <- summary(package_network)
plot(package_summaries, according_to = "n_imported_by", top = 20)

plot(package_summaries, according_to = "page_rank", top = 20)

### Why is patchSynctex so high on page rank?
##pkg_network <- build_network(objects = package_db, perspective = "package")
##plot(pkg_network, package = "patchSynctex")

author_network <- build_network(object = package_db, perspective = "author")
plot(author_network, author = "Bendix Carstensen", exact = FALSE)

Epi_tree <- build_dependence_tree(package_network, "Epi")
plot(Epi_tree)

epi_packages <- package_with(package_network, name = c("epi"))
plot(package_network, package = epi_packages, legend=FALSE)
