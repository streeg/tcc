/*
 * Copyright (c) 2015-2017  Erik Derr [derr@cs.uni-saarland.de]
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not use this
 * file except in compliance with the License. You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software distributed under
 * the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied. See the License for the specific language governing
 * permissions and limitations under the License.
 */

package de.infsec.tpl.profile;

import java.io.Serializable;
import java.util.Collection;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.github.zafarkhaja.semver.Version;

import de.infsec.tpl.hashtree.HashTree;
import de.infsec.tpl.pkg.PackageTree;
import de.infsec.tpl.utils.Pair;
import de.infsec.tpl.utils.VersionWrapper;

/**
 * A LibProfile instance includes any information about a particular version of a library.
 * This includes parsed meta data as well as generated package/hash-trees.
 */

public class LibProfile extends Profile implements Serializable {
	private static final long serialVersionUID = 7810050746806720101L;

	public static LibProfileComparator comp = new LibProfileComparator();
	
	// basic facts about the library, read from XML file
	public LibraryDescription description;
	private boolean isDeprecated = true;   // flag to indicate if this is the most current version of a library (according to our DB)
	
	public LibProfile(final LibraryDescription desc, final PackageTree packageTree, final List<HashTree> hashTrees) {
		super(packageTree, hashTrees);
		this.description = desc;
	}
	
	@Override
	public String toString() {
		return this.description.name + " (" + this.description.version + ")";
	}
	
	public boolean isDeprecatedLib() {
		return isDeprecated;
	}
	
	public void setIsDeprecatedLib(boolean isDeprecated) {
		this.isDeprecated = isDeprecated;
	}
	

	// compares library names first then library versions
	public static class LibProfileComparator implements Comparator<LibProfile> {
		@Override
		public int compare(LibProfile p0, LibProfile p1) {
			if (p0.description.name.equals(p1.description.name)) {
				try {
					// Compare by version string according to SemVer rules
					Version v0 = VersionWrapper.valueOf(p0.description.version);
					Version v1 = VersionWrapper.valueOf(p1.description.version);
	
					return v0.compareWithBuildsTo(v1);
				} catch (Exception e) {
					// if versions do not adhere to semver rules and cannot be
					// easily transformed into compliant version string,
					// do string compare as fallback
					return 	p0.description.version.compareTo(p1.description.version);
				}
			}

			return p0.description.name.compareTo(p1.description.name);
		}
	}
	
	
	/**
	 * Given a collection of profiles, return distinct libraries with their highest version
	 * @param profiles
	 * @return a {@link Map} containing unique library names -> highest version
	 */
	public static Map<String,String> getUniqueLibraries(Collection<LibProfile> profiles) {
		HashMap<String,String> result = new HashMap<String,String>();
		for (LibProfile p: profiles) {
			if (!result.containsKey(p.description.name))
				result.put(p.description.name, p.description.version);
			else {
				try {
					Version v1 = VersionWrapper.valueOf(result.get(p.description.name));
					Version v2 = VersionWrapper.valueOf(p.description.version);
	
					if (v2.greaterThan(v1))
						result.put(p.description.name, p.description.version);
				} catch (Exception e) { /* if at least one version is not semver compliant */ }
			}
		}
		return result;
	}
	
	
	public Pair<String,String> getLibIdentifier() {
		return new Pair<String,String>(description.name, description.version);
	}
}
