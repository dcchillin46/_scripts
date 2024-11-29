<html>
<h1 align="center">Scripts for the Site That Rhymes with Orient</h1>
<p align="center">Scripts to streamline the process of filtering and downloading large numbers of files for local preservation and storage.</p>

<h2>Provided Scripts:</h2>
<ul>
    <li>rclone_list.sh</li>
    <li>rclone_listsize.sh</li>
    <li>rclone_copy.sh</li>
    <li>unzip_directory.sh</li>
    <li>chd_clean.sh</li>
</ul>
    
<h2 align="left">Usage</h2>
<p>Download the scripts and extract them in any directory. You can pass target directories as arguments when starting a script. They're shell scripts, so you should probably be using a Linux machine or WSL. You will also need rclone installed. In the terminal, navigate to the script directory.</p>

<p><b>Typical Workflow:</b>
<ol>
    <li>Check the total number of files using <b>rclone_list</b>. Look at returned results for any additional filters that may be needed. Modify and retry if desired.</li>
    <li>Once filters have been refined, run <b>rclone_listsize</b> to see the total file size. Ensure enough storage is available for the desired transfer.</li>
    <li>Run rclone_copy to transfer all files to local storage.</li>
    <li>If <i>.zip</i> files are not functional, run <b>unzip_directory</b> to unzip all files in the target directory.</li>
    <li>Many disc-based games can utilize <i>.chd</i> files. Use <a href="https://wiki.recalbox.com/en/tutorials/utilities/rom-conversion/chdman">chdman</a> <i>(external, not included)</i> or similar tools to convert various file types and tracks to .chd format.</li>
    <li>Run <b>chd_clean</b> to remove all <i>.bin</i>, <i>.cue</i>, <i>.iso</i> files that have already been converted to <i>.chd</i> and have a matching <i>.chd</i> present in the directory.</li>
    <li>Happy Preserving!</li>
</ol>
</p>

<h2>Details</h2>
<h3>rclone_list.sh:</h3>
<p>Headless search with filters. Provides a quick list of files that match your search criteria with a total number. No file size information is provided.</p>
<ul>
    <li><b>Usage:</b> ./rclone_list.sh &lt;http_url&gt; [optional additional filters]</li>
    <li><b>Example:</b> rclone_list.sh http://example.com "+ *Japan*" "- *Europe*"</li>
    <ul>
        <li>Defaults to filtering for only USA releases.</li>
        <li>Default filters can be easily edited by modifying the script file.</li>
        <li>Wrap filters in quotes.</li>
        <li>Adding too many additional filter conditions can slow or break things, so just be cautious.</li>
        <li>Add asterisks to search for files with the keyword anywhere in the file name. Be careful; filtering *re* for re-releases will skip all files that contain "re," such as pResident shmEvil.</li>
        <li>Open the script in Notepad, Word <i>(if you're a maniac)</i>, Notepad++ <i>(the right answer)</i>, or any IDE to edit the DEFAULT_FILTERS section and set new defaults.</li>
    </ul>
</ul>
   
<h3>rclone_listsize.sh:</h3>
<p>Searches <b><i>WITH</i></b> headers enabled. This search will take longer, depending on the quantity of matches and file sizes, but will provide the total size of matches along with the number of files.</p>
<ul>
    <li><b>Usage:</b> ./rclone_listsize.sh &lt;http_url&gt; [optional additional filters]</li>
    <li><b>Example:</b> rclone_listsize.sh http://example.com "+ *Japan*" "- *Europe*"</li>
    <ul>
        <li>Functions the same as the other list script but provides information on total file size.</li>
        <li>This script can take significantly longer depending on the number of matching files and their sizes. Expect minutes or more for directories over 100GB.</li>
    </ul>
</ul>

<h3>rclone_copy.sh:</h3>
<p>Copies files matching criteria to the specified local directory.</p>
<ul>
    <li><b>Usage:</b> ./rclone_copy.sh &lt;http_url&gt; &lt;destination_directory&gt; [optional additional filters]</li>
    <li><b>Example:</b> rclone_copy.sh http://example.com /path/to/destination "+ *Japan*" "- *Europe*"</li>
    <ul>
        <li>This script will take time to process depending on the number and size of matching files, as well as your network connection. If the terminal is closed or the system goes to sleep, the download will stop.</li>
    </ul>
</ul>

<h3>unzip_directory.sh:</h3>
<p>Unzips all .zip files in the specified directory. Prompts the user before the script starts to delete .zip files after extraction or to retain them for future use.</p>
<ul>
    <li><b>Usage:</b> unzip_directory.sh &lt;source_directory&gt; &lt;destination_directory&gt;</li>
    <li><b>Example:</b> unzip_directory.sh /path/to/source /path/to/destination <i>(CAN be the same)</i></li>
    <ul>
        <li>Make sure you have sufficient storage if you choose to retain .zip files. Extraction will significantly increase storage requirements for larger files.</li>
    </ul>
</ul>

<h3>chd_clean.sh:</h3>
<p>Removes all precursor files from a directory after conversion to <i>.chd</i>. Any (and only) <i>.bin</i>, <i>.cue</i>, and <i>.iso</i> files that <b>have a matching .chd also present in the directory</b> will be removed. Users will be prompted for confirmation for each file or can approve en masse.</p>
<ul>
    <li><b>Usage:</b> chd_clean.sh &lt;target_directory&gt;</li>
    <li><b>Example:</b> chd_clean.sh /path/to/directory</li>
    <ul>
        <li>Option to approve or deny each file individually.</li>
        <li>Option to approve all available files after each file.</li>
    </ul>
</ul>

<br><br><br><br>

<h5>Other Stuff</h5>
<hr>
<p>I'm pretty new to all of this. GPT did the heavy lifting to get the scripts started. I refined and tested. If you have suggestions or run into issues, please let me know. There isn't really anything fancy here, just a way to expedite things and reduce repetitive typing.</p>
    
<p>Use the scripts with caution. Some filter combinations have unexpected results. I tried to add as many precautions as possible when permanently altering or removing files, but it's possible I missed something.</p>
