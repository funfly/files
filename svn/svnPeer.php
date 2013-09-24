<?php
  /**
   *
   * This class for execute the external program of svn
   *
   * @auth Seven Yang <qineer@gmail.com>
   *
   */
define('SVN_USERNAME', 'funfly');
define('SVN_PASSWORD', '123456');

class svnPeer
{

  /**
   * List directory entries in the repository
   *
   * @param string a specific project repository path
   * @return bool true, if validated successfully, otherwise false
   */
  static public function ls($repository)
  {
    $command = "svn ls " . $repository;
    $output  = svnPeer::runCmd($command);
    $output  = implode("<br>", $output);
    if (strpos($output, 'non-existent in that revision')) {
      return false;
    }

    return "<br>" . $command . "<br>" . $output;
  }

  /**
   * Duplicate something in working copy or repository, remembering history
   *
   * @param $src
   * @param $dst
   * @param $comment string specify log message
   * @return bool true, if copy successfully, otherwise return the error message
   *
   * @todo comment need addslashes for svn commit
   */
  static public function copy($src, $dst, $comment)
  {
    $command = "svn cp $src $dst -m '$comment'";
    $output  = svnPeer::runCmd($command);
    $output  = implode("<br>", $output);

    if (strpos($output, 'Committed revision')) {
      return true;
    }

    return "<br>" . $command . "<br>" . $output;
  }

  /**
   * Remove files and directories from version control
   *
   * @param $url
   * @return bool true, if delete successfully, otherwise return the error message
   *
   * @todo comment need addslashes for svn commit
   */
  static public function delete($url, $comment)
  {
    $command = "svn del $url -m '$comment'";
    $output  = svnPeer::runCmd($command);
    $output  = implode('<br>', $output);
    if (strpos($output, 'Committed revision')) {
      return true;
    }

    return "<br>" . $command . "<br>" . $output;
  }

  /**
   * Move and/or rename something in working copy or repository
   *
   * @param $src string trunk path
   * @param $dst string new branch path
   * @param $comment string specify log message
   * @return bool true, if move successfully, otherwise return the error message
   *
   * @todo comment need addslashes for svn commit
   */
  static public function move($src, $dst, $comment)
  {
    $command = "svn mv $src $dst -m '$comment'";
    $output  = svnPeer::runCmd($command);
    $output  = implode('<br>', $output);

    if (strpos($output, 'Committed revision')) {
      return true;
    }

    return "<br>" . $command . "<br>" . $output;
  }

  /**
   * Create a new directory under version control
   *
   * @param $url string
   * @param $comment string the svn message
   * @return bool true, if create successfully, otherwise return the error message
   *
   * @todo comment need addslashes for svn commit
   */
  static public function mkdir($url, $comment)
  {
    $command = "svn mkdir $url -m '$comment'";
    $output  = svnPeer::runCmd($command);
    $output  = implode('<br>', $output);

    if (strpos($output, 'Committed revision')) {
      return true;
    }

    return "<br>" . $command . "<br>" . $output;
  }

  static public function diff($pathA, $pathB)
  {
    $output = svnPeer::runCmd("svn diff $pathA $pathB");
    return implode('<br>', $output);
  }

  //导出最新版本
  static public function export($url, $dir)
  {
    $command = "cd $dir && svn export $url";
    $output  = svnPeer::runCmd($command);
    $output  = implode('<br>', $output);
    if (strstr($output, 'Exported revision')) {
      return true;
    }

    return "<br>" . $command . "<br>" . $output;
  }

  //回滚到任意版本
  static public function rollback($url,$dir,$revision)
  {
    $command = "cd $dir && svn export -r $revision $url";
    $output  = svnPeer::runCmd($command);
    $output  = implode('<br>', $output);
    if (strstr($output, 'Exported revision')) {
      return true;
    }

    return "<br>" . $command . "<br>" . $output;
  }

  //检出
  static public function checkout($url, $dir)
  {
    $command = "cd $dir && svn co $url";
    $output  = svnPeer::runCmd($command);
    $output  = implode('<br>', $output);
    if (strstr($output, 'Checked out revision')) {
      return true;
    }

    return "<br>" . $command . "<br>" . $output;
  }

  //更新
  static public function update($path)
  {
    $command = "cd $path && svn up";
    $output  = svnPeer::runCmd($command);
    $output  = implode('<br>', $output);

    preg_match_all("/[0-9]+/", $output, $ret);
    if (!$ret[0][0]){
      return "<br>" . $command . "<br>" . $output;
    }

    return $ret[0][0];
  }


  static public function merge($revision, $url, $dir)
  {
    $command = "cd $dir && svn merge -r1:$revision $url";
    $output  = implode('<br>', svnPeer::runCmd($command));
    if (strstr($output, 'Text conflicts')) {
      return 'Command: ' . $command .'<br>'. $output;
    }

    return true;
  }

  static public function commit($dir, $comment)
  {
    $command = "cd $dir && svn commit -m'$comment'";
    $output  = implode('<br>', svnPeer::runCmd($command));

    if (strpos($output, 'Committed revision') || empty($output)) {
      return true;
    }

    return $output;
  }

  static public function getStatus($dir)
  {
    $command = "cd $dir && svn st";
    return svnPeer::runCmd($command);
  }

  static public function hasConflict($dir)
  {
    $output = svnPeer::getStatus($dir);
    foreach ($output as $line){
      if ('C' == substr(trim($line), 0, 1) || ('!' == substr(trim($line), 0, 1))){
        return true;
      }
    }

    return false;
  }

  /**
   * Show the log messages for a set of path with XML
   *
   * @param path string
   * @return log message string
   */
  static public function getLog($path)
  {
    $command = "svn log $path --xml";
    $output  = svnPeer::runCmd($command);
    return implode('', $output);
  }

  static public function getPathRevision($path)
  {
    $command = "svn info $path --xml";
    $output  = svnPeer::runCmd($command);
    $string  = implode('', $output);
    $xml     = new SimpleXMLElement($string);
    foreach ($xml->entry[0]->attributes() as $key=>$value){
      if ('revision' == $key) {
        return $value;
      }
    }
  }

  static public function getHeadRevision($path)
  {
    $command = "cd $path && svn up";
    $output  = svnPeer::runCmd($command);
    $output  = implode('<br>', $output);

    preg_match_all("/[0-9]+/", $output, $ret);
    if (!$ret[0][0]){
      return "<br>" . $command . "<br>" . $output;
    }

    return $ret[0][0];
  }

 /**
  * Run a cmd and return result
  *
  * @param string command line
  * @param boolen true need add the svn authentication
  * @return array the contents of the output that svn execute
  */
  static protected function runCmd($command)
  {
    $authCommand = ' --username ' . SVN_USERNAME . ' --password ' . SVN_PASSWORD . ' --no-auth-cache --non-interactive ';
    exec($command . $authCommand . " 2>&1", $output);

    return $output;
  }
}

$svnPeer = new svnPeer;

$url = "svn://192.168.56.10:3000/repos/web";
$dir = "/home/www/www.funfly.com/";
//$re = $svnPeer->export($url,$dir);
//$re = $svnPeer->getLog($url);
$revision = 3;
$re = $svnPeer->rollback($url,$dir,$revision);
print_r($re);



?>