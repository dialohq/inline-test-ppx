(lang dune 2.0)

(name inline-test-ppx)

(source
 (github dialohq/inline-test-ppx))

(license MIT)

(authors "Paul TSNOBILADZE")

(maintainers "Paul TSNOBILADZE")

(generate_opam_files true)

(allow_approximate_merlin)

(package
 (name inline-test-ppx)
 (synopsis "A PPX to write inline tests in rescript")
 (description "A PPX to write inline tests in rescript\n")
 (depends
  (ocaml
   (>= 4.08.0))
  (dune
   (>= 2.0))
  (alcotest :with-test)
  (odoc :with-doc)
  (ppxlib :build)))
