# ----------------------------------------------------------------------
# This is a script that assumes the the input file contains the
# solution text as tex, and that the **ENTIRE** text from the exercise
# as commented lines starting with "% ". Note the space after "%"
#
# The point of this clunky set-up is to be able to maintain exercise
# and solution text in the same file. The drawback is that nothing can
# be reused between the -e (exercise) and -s (solution) files.
#
# The commented part of the file is extracted and copied to the
# exercise part (-e.rnw); the non-commented part file is extracted and
# copied to the solution-version (-s.rnw).
#
# Then Rweave is run on both.
#
# The temporary file qzwr.rnw is needed in order to avoid
# cmd-constructs in the lines with grep and sed.
# ----------------------------------------------------------------------
cp $1.rnw qzwr.rnw
grep    "^%% " qzwr.rnw | sed 's/^%% //' > $1-e.rnw
grep -v "^%% " qzwr.rnw                 > $1-s.rnw
R CMD Sweave $1-e.rnw
R CMD Sweave $1-s.rnw
# rm $1-e.rnw
# rm $1-s.rnw
rm qzwr.rnw
