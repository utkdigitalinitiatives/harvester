<?php

/**
 * Harvester.inc.php
 *
 * Copyright (c) 2005 The Public Knowledge Project
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @package harvester
 *
 * Generic harvester
 *
 * $Id$
 */

class Harvester {
	/** @var $errors array */
	var $errors;

	/** @var $fieldDao object */
	var $fieldDao;

	/** @var $recordDao object */
	var $recordDao;

	/** @var $archive object */
	var $archive;

	function Harvester($archive) {
		$this->errors = array();

		$this->fieldDao =& DAORegistry::getDAO('FieldDAO');
		$this->recordDao =& DAORegistry::getDAO('RecordDAO');

		$this->archive =& $archive;
	}

	function &getFieldByKey($fieldKey) {
		$returner =& $this->fieldDao->getFieldByKey($fieldKey);
		return $returner;
	}

	function &getRecordByIdentifier($identifier) {
		$returner =& $this->recordDao->getRecordByIdentifier($identifier);
		return $returner;
	}

	function insertRecord(&$record) {
		return $this->recordDao->insertRecord($record);
	}

	function deleteEntries(&$record) {
		return $this->recordDao->deleteEntriesByRecordId($record->getRecordId());
	}

	function addEntry(&$record, &$field, $value) {
		if (is_array($value)) foreach ($value as $item) {
			return $this->recordDao->insertEntry(
				$record->getRecordId(),
				$field->getFieldId(),
				$field->getType(),
				$item
			);
		} else {
			return $this->recordDao->insertEntry(
				$record->getRecordId(),
				$field->getFieldId(),
				$field->getType(),
				$value
			);
		}
	}

	/**
	 * Return an array of error messages.
	 */
	function getErrors() {
		return $this->errors;
	}

	/**
	 * Get the archive object.
	 */
	function &getArchive() {
		return $this->archive;
	}

	/**
	 * Get the status of the harvester. False iff errors occurred.
	 */
	function getStatus() {
		return (empty($this->errors));
	}

	/**
	 * Add an error to the current list.
	 * @param $error string
	 */
	function addError($error) {
		array_push($this->errors, $error);
	}

	/**
	 * Get an iterator of records since the given UNIX timestamp.
	 * @param $recordHandler object
	 * @param $lastUpdateTimestamp int
	 * @return mixed false iff error, record count otherwise
	 */
	function updateRecords(&$recordHandler, $lastUpdateTimestamp) {
		fatalError ('ABSTRACT CLASS');
	}
}

?>